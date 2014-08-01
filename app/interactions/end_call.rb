class EndCall
  def self.with(params)
    EndCall.new(params[:access_token]).execute
  end

  attr_accessor :access_token
  attr_accessor :notification_service

  def initialize(access_token)
    @access_token = access_token
  end

  def execute
    user = User.find_by_token(access_token)

    @notification_service ||= NotificationService.new
    @notification_service.end_call(PhoneNumber.new(user: user), '')
  end
end
