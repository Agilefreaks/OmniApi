class Sms
  def self.with(params)
    Sms.new(params[:access_token], params[:phone_number], params[:content]).execute
  end

  attr_accessor :notification_service

  def initialize(access_token, phone_number, content)
    @access_token = access_token
    @phone_number = phone_number
    @content = content
  end

  def execute
    user = User.find_by_token(@access_token)

    @notification_service ||= NotificationService.new
    @notification_service.sms(SmsMessage.new(user: user, phone_number: @phone_number, content: @content), '')
  end
end
