class CreateClipping
  def self.with(params)
    CreateClipping.new(params).create
  end

  attr_reader :channel, :content, :identifier
  attr_accessor :clipping_factory, :notification_service

  def initialize(args)
    @channel = args['channel']
    @content = args['content']
    @identifier = args['identifier']
  end

  def create
    @clipping_factory ||= ClippingFactory.new
    @notification_service ||= NotificationService.new

    clipping = @clipping_factory.create(@channel, @content)
    @notification_service.notify(clipping, @identifier)

    clipping
  end
end
