module Sms
  class Send
    def self.with(params)
      Send.new(params).send
    end

    attr_reader :id, :state, :device_id

    def initialize(params)
      @id = params[:id]
      @state = params[:state]
      @device_id = params[:device_id]
    end

    def send
      sms_message = SmsMessage.scheduled.find(@id)
      NotificationService.new.send_sms_message_requested(sms_message, @device_id)
      sms_message.update_attributes(state: @state)

      sms_message
    end
  end
end