class CreateNotification
  def self.with(params)
    CreateNotification.new(params).create
  end

  attr_reader :access_token, :identifier, :type, :payload
  attr_accessor :notification_factory, :notification_service

  def initialize(params)
    @access_token = params[:access_token]
    @identifier = params[:identifier]
    @type = params[:type]
    @payload = params[:incoming_call]
  end

  def create
    @notification_factory ||= NotificationFactory.new(@access_token)
    @notification_service ||= NotificationService.new

    notification = @notification_factory.create(@type, @payload.merge(identifier: @identifier))
    @notification_service.notify(notification, @identifier)

    notification
  end
end
