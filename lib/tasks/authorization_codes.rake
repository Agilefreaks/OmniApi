namespace :authorization_codes do
  desc 'active but not user, expired'
  task expired_active_count: :environment do
    # User.where(authorization_codes:
    #              { '$elemMatch' =>
    #                  { code: code, active: true, :expires_at.lt => Time.now.utc }
    #              }).count
  end

  desc 'remove not active'
  task remove_expired: :environment do
    User.all.each do |u|
      u.authorization_codes.unscoped.where(active: false).destroy
    end
  end
end
