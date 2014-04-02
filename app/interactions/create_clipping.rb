class CreateClipping
  def self.with(params)
    CreateClipping.new(params).create
  end

  attr_reader :access_token, :content, :identifier
  attr_accessor :clipping_factory, :notification_service

  def initialize(args)
    @access_token = args[:access_token]
    @content = args[:content]
    @identifier = args[:identifier]
  end

  def create
    @clipping_factory ||= ClippingFactory.new
    @notification_service ||= NotificationService.new

    clipping = @clipping_factory.create(@access_token, @content)
    @notification_service.notify(clipping, @identifier)

    clipping
  end
end
