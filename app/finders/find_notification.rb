class FindNotification
  def self.for(token, notification_id)
    user = User.find_by_token(token)
    user.notifications.find(notification_id)
  end
end