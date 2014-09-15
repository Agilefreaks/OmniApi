namespace :migrate do
  task clippings: :environment do
    User.each do |user|
      if !user.access_tokens.empty? && user.access_tokens.last.valid?
        FindClipping.for(user.access_tokens.last.token)
        user.clippings.destroy_all
      end
    end
  end
end
