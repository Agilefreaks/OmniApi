class Sms
  class SmsMessageParams
    attr_accessor :phone_number, :phone_number_list, :content, :content_list, :access_token, :state, :device_id,
                  :contact_name, :contact_name_list

    def initialize(params)
      @phone_number = params[:phone_number]
      @phone_number_list = params[:phone_number_list]
      @content = params[:content]
      @content_list = params[:content_list]
      @contact_name = params[:contact_name]
      @contact_name_list = params[:contact_name_list]
      @access_token = params[:access_token]
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
      contact_name_list: @params.contact_name_list || []
    )

    case @params.state
    when :incoming
      @notification_service.incoming_sms_message(sms_message, @params.device_id)
      backwards_compatibility
    end

    sms_message
  end

  private

  def backwards_compatibility
    type = :incoming_sms
    payload = { phone_number: @params.phone_number, contact_name: @params.contact_name, content: @params.content  }
    CreateEvent.with(
      access_token: @params.access_token,
      type: type, incoming_sms: payload,
      identifier: @params.device_id)
  end
end
