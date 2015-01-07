class EndCall
  def self.with(params)
    EndCall.new(params[:access_token], params[:id]).execute
  end

  attr_accessor :access_token, :id
  attr_accessor :notification_service

  def initialize(access_token, id)
    @access_token = access_token
    @id = id
  end

  def execute
    user = User.find_by_token(access_token)

    @notification_service ||= NotificationService.new

    phone_call = user.phone_calls.find(@id)
    @notification_service.end_call(phone_call, '')

    phone_call
  end
end
