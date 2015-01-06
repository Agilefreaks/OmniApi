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

    phone_call = user.phone_calls.create(number: @phone_number)
    @notification_service.call(phone_call, '')

    phone_call
  end
end
