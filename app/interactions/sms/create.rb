module Sms
  class Create
    def self.with(params)
      Create.new(params).execute
    end

    attr_reader :access_token, :type, :state, :device_id, :sms_message_params
    attr_accessor :notification_service

    def initialize(params)
      @access_token = params[:access_token]
      @type = params[:type]
      @state = params[:state]
      @device_id = params[:device_id]
      @sms_message_params = params.slice(
        :phone_number, :phone_number_list,
        :content, :content_list,
        :contact_name, :contact_id, :contact_name_list,
        :state, :scheduled_at)
      @notification_service ||= NotificationService.new
    end

    # rubocop:disable MethodLength, AbcSize
    def execute
      user = User.find_by_token(@access_token)

      sms_message = user.sms_messages.create(
        phone_number: @sms_message_params[:phone_number],
        phone_number_list: @sms_message_params[:phone_number_list] || [],
        content: @sms_message_params[:content],
        content_list: @sms_message_params[:content_list] || [],
        contact_name: @sms_message_params[:contact_name],
        contact_id: @sms_message_params[:contact_id],
        contact_name_list: @sms_message_params[:contact_name_list] || [],
        state: @sms_message_params[:state],
        scheduled_at: @sms_message_params[:scheduled_at]
      )

      send("#{@type}_#{@state}", sms_message, @device_id)

      sms_message
    end

    private

    def outgoing_scheduled(sms_message, device_id)
      OmniKiq::Workers::SendScheduledSmsWorker.perform_at(sms_message.scheduled_at, sms_message.id, device_id)
    end

    def outgoing_sending(sms_message, device_id)
      @notification_service.send_sms_message_requested(sms_message, device_id)
    end

    def incoming_received(sms_message, device_id)
      @notification_service.sms_message_received(sms_message, device_id)
    end
  end
end
