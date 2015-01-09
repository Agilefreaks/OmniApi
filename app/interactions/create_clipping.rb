class CreateClipping
  def self.with(params)
    CreateClipping.new(params).create
  end

  attr_reader :access_token, :content, :device_id
  attr_accessor :clipping_builder, :notification_service

  def initialize(args)
    @access_token = args[:access_token]
    @content = args[:content]
    @device_id = args[:identifier] || args[:device_id]
  end

  def create
    @clipping_builder ||= ClippingBuilder.new
    @notification_service ||= NotificationService.new

    clipping = @clipping_builder.build(@access_token, @content)
    @notification_service.notify(clipping, @device_id)

    clipping
  end
end
