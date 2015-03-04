module Call
  class Update
    def self.with(params)
      Update.new(params).update
    end

    attr_reader :access_token, :id, :device_id, :state, :type

    def initialize(params)
      @access_token = params[:access_token]
      @id = params[:id]
      @device_id = params[:device_id]
      @state = params[:state]
      @type = params[:type]
    end

    def update
      user = User.find_by_token(access_token)

      phone_call = user.phone_calls.find(@id)
      phone_call.update_attribute(:state, state)

      send("#{@type}_#{@state}", phone_call, @device_id)

      phone_call
    end

    def incoming_ending(phone_call, device_id)
      NotificationService.new.end_phone_call_requested(phone_call, device_id)
    end

    def incoming_ended(phone_call, device_id)
      NotificationService.new.phone_call_ended(phone_call, device_id)
    end

    def outgoing_started(phone_call, device_id)
      NotificationService.new.outgoing_started(phone_call, device_id)
    end
  end
end
