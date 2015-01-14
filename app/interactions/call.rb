class Call
  class CallParams
    attr_accessor :access_token, :number, :contact_name, :device_id, :state

    def initialize(params)
      @access_token = params[:access_token]
      @number = params[:number]
      @contact_name = params[:contact_name]
      @device_id = params[:device_id]
      @state = params[:state]
    end
  end

  def self.with(params)
    Call.new(CallParams.new(params)).execute
  end

  attr_accessor :call_params
  attr_accessor :notification_service

  def initialize(call_params)
    @call_params = call_params
  end

  # rubocop:disable MethodLength
  def execute
    user = User.find_by_token(@call_params.access_token)

    @notification_service ||= NotificationService.new

    phone_call = user.phone_calls.create(number: @call_params.number, contact_name: @call_params.contact_name)
    case @call_params.state
    when :initiate
      @notification_service.call(phone_call, @call_params.device_id)
    when :incoming
      @notification_service.incoming_call(phone_call, @call_params.device_id)
      backwards_compatibility
    end

    phone_call
  end

  def backwards_compatibility
    type = :incoming_call
    payload = { phone_number: @call_params.number, contact_name: @params.contact_name  }
    CreateEvent.with(
      access_token: @call_params.access_token,
      type: type, incoming_call: payload,
      identifier: @call_params.device_id)
  end
end
