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
    end

    def update
      sms_message = SmsMessage.find(@id)
      sms_message.update_attributes(@update_attributes)

      if (@update_attributes[:state] == 'sent')
        NotificationService.new.sms_message_sent(sms_message, @device_id)
      elsif (@update_attributes[:state] == 'sending')
        NotificationService.new.send_sms_message_requested(sms_message, @device_id)
      end

      sms_message
    end
  end
end
