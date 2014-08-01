class Call
  def self.with(params)
    Call.new(params[:access_token], params[:phone_number]).execute
  end

  attr_accessor :access_token, :phone_number
  attr_accessor :notification_service

  def initialize(access_token, phone_number)
    @access_token = access_token
    @phone_number = phone_number
  end

  def execute
    user = User.find_by_token(access_token)

    @notification_service ||= NotificationService.new
    @notification_service.call(PhoneNumber.new(user: user, content: @phone_number), '')
  end
end
