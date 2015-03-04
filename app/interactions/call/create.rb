module Call
  class Create
    class CallParams
      attr_accessor :access_token, :number, :contact_name, :contact_id, :device_id, :state, :type

      def initialize(params)
        @access_token = params[:access_token]
        @number = params[:number]
        @contact_name = params[:contact_name]
        @contact_id = params[:contact_id]
        @device_id = params[:device_id]
        @state = params[:state]
        @type = params[:type]
      end
    end

    def self.with(params)
      Create.new(CallParams.new(params)).execute
    end

    attr_accessor :call_params
    attr_accessor :notification_service

    def initialize(call_params)
      @call_params = call_params
    end

    def execute
      user = User.find_by_token(@call_params.access_token)

      @notification_service ||= NotificationService.new

      phone_call = user.phone_calls.create(
        number: @call_params.number,
        contact_name: @call_params.contact_name,
        contact_id: @call_params.contact_id
      )

      send("#{@call_params.type}_#{@call_params.state}", phone_call, @call_params.device_id)

      phone_call
    end

    private

    def incoming_starting(phone_call, device_id)
      @notification_service.phone_call_received(phone_call, device_id)
    end

    def outgoing_starting(phone_call, device_id)
      @notification_service.start_phone_call_requested(phone_call, device_id)
    end
  end
end