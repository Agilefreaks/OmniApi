class CreateEvent
  def self.with(params)
    CreateEvent.new(params).create
  end

  attr_reader :access_token, :identifier, :type, :payload
  attr_accessor :event_factory, :notification_service

  def initialize(params)
    @access_token = params[:access_token]
    @identifier = params[:identifier]
    @type = params[:type]
    @payload = params[:incoming_call]
  end

  def create
    @event_factory ||= EventFactory.new(@access_token)
    @notification_service ||= NotificationService.new

    event = @event_factory.create(@type, @payload.merge(identifier: @identifier))
    @notification_service.notify(event, @identifier)

    event
  end
end
