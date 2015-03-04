class UpdateSms
  def self.with(params)
    UpdateSms.new(params).update
  end

  attr_reader :token, :id, :update_attributes

  def initialize(params)
    @token = params[:access_token]
    @id = params[:id]
    @device_id = params[:device_id]
    @update_attributes = params.slice(:state)
  end

  def update
    user = User.find_by_token(@token)
    sms_message = user.sms_messages.find(@id)
    sms_message.update_attributes(@update_attributes)
    NotificationService.new.sms_message_sent(sms_message, @device_id)

    sms_message
  end
end
