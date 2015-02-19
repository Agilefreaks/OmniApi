class Sms
  class SmsMessageParams
    attr_accessor :phone_number, :phone_number_list,
                  :content, :content_list,
                  :contact_name, :contact_id, :contact_name_list,
                  :access_token,
                  :device_id,
                  :state,
                  :type

    def initialize(params)
      @phone_number = params[:phone_number]
      @phone_number_list = params[:phone_number_list]
      @content = params[:content]
      @content_list = params[:content_list]
      @contact_name = params[:contact_name]
      @contact_id = params[:contact_id]
      @contact_name_list = params[:contact_name_list]
      @access_token = params[:access_token]
      @type = params[:type]
      @state = params[:state]
      @device_id = params[:device_id]
    end
  end

  def self.with(params)
    Sms.new(SmsMessageParams.new(params)).execute
  end

  attr_reader :params
  attr_accessor :notification_service

  def initialize(params)
    @params = params
  end

  # rubocop:disable MethodLength, AbcSize
  def execute
    user = User.find_by_token(@params.access_token)

    @notification_service ||= NotificationService.new

    sms_message = user.sms_messages.create(
      phone_number: @params.phone_number,
      phone_number_list: @params.phone_number_list || [],
      content: @params.content,
      content_list: @params.content_list || [],
      contact_name: @params.contact_name,
      contact_id: @params.contact_id,
      contact_name_list: @params.contact_name_list || []
    )

    send("#{@params.type}_#{@params.state}", sms_message, @params.device_id)

    sms_message
  end

  private

  def outgoing_sending(sms_message, device_id)
    @notification_service.send_sms_message_requested(sms_message, device_id)
  end

  def incoming_received(sms_message, device_id)
    @notification_service.sms_message_received(sms_message, device_id)
  end
end
