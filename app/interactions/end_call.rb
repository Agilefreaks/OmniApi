class EndCall
  def self.with(params)
    EndCall.new(params[:access_token], params[:id], params[:device_id]).execute
  end

  attr_accessor :access_token, :id, :device_id
  attr_accessor :notification_service

  def initialize(access_token, id, device_id)
    @access_token = access_token
    @id = id
    @device_id = device_id
  end

  def execute
    user = User.find_by_token(access_token)

    @notification_service ||= NotificationService.new

    phone_call = user.phone_calls.find(@id)
    phone_call.update_attribute(:state, :end_call)
    @notification_service.end_phone_call_requested(phone_call, @device_id)

    # TODO: remove old method once the clients are updated
    @notification_service.end_call(phone_call, @device_id)

    phone_call
  end
end
