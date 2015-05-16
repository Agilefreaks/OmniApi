module Sms
  class Update
    def self.with(params)
      Update.new(params).update
    end

    attr_reader :token, :id, :update_attributes

    def initialize(params)
      @token = params[:access_token]
      @id = params[:id]
      @device_id = params[:device_id]
      @update_attributes = params.slice(:state)
      @notification_service ||= NotificationService.new
    end

    def update
      sms_message = SmsMessage.find(@id)
      previous_state = sms_message.state
      sms_message.update_attributes(@update_attributes)

      notify(previous_state, sms_message)

      sms_message
    end

    def notify(previous_state, sms_message)
      current_state = sms_message.state

      if previous_state == 'sending' && current_state == 'sent'
        @notification_service.sms_message_sent(sms_message, @device_id)
      elsif previous_state == 'scheduled' && current_state == 'sending'
        @notification_service.send_sms_message_requested(sms_message, @device_id)
      end
    end
  end
end
