class NotificationFactory
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def create(type, params = {})
    user = User.find_by_token(@token)

    notification_klass = type.to_s.split('_').map(&:capitalize).join.concat('Notification').constantize
    notification = notification_klass.new(params)
    user.notifications.push(notification)
    user.save

    notification
  end
end
