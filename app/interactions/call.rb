class Call
  def self.with(params)
    Call.new(params[:token], params[:phone_number]).execute
  end

  attr_accessor :token, :phone_number
  attr_accessor :notification_service

  def initialize(token, phone_number)
    @token = token
    @phone_number = phone_number
  end

  def execute
    user = User.find_by_token(token)

    @notification_service ||= NotificationService.new
    @notification_service.notify(PhoneNumber.new(user: user, content: phone_number), '')
  end
end
