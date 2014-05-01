class FindNotification
  def self.for(token)
    user = User.find_by_token(token)
    user.notifications.last
  end
end
