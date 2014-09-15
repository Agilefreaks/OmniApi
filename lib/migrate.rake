namespace :migrate do
  task clippings: :environment do
    User.each do |user|
      FindClipping.for(user.access_tokens.last.token) if !user.access_tokens.empty? && user.access_tokens.last.valid?
    end
  end
end
