class SendSmsMessage
  def self.with(params)
    SendSmsMessage.new(params).execute
  end

  attr_reader :params
  attr_accessor :notification_service

  def initialize(params)
    @access_token = params.delete(:access_token)
    @params = params
  end

  def execute
    user = User.find_by_token(@access_token)

    @notification_service ||= NotificationService.new

    sms_message = user.sms_messages.create(@params)

    # TODO: remove this code once the new android version has rolled out to all user
    if sms_message.phone_number_list.empty?
      @notification_service.sms(sms_message)
    else
      @notification_service.sms_message(sms_message)
    end
  end
end
