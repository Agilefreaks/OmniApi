# rubocop:disable MethodLength
module TrackHelper
  extend Grape::API::Helpers

  def track(params, event = nil)
    TrackingService.event(@current_user.email, event, params)

    return if @current_user.mixpanel_profile_updated?

    TrackingService.people(@current_user.email,
                           '$first_name' => @current_user.first_name,
                           '$last_name' => @current_user.last_name,
                           '$email' => @current_user.email,
                           '$mixpanel_profile_updated' => true)
    @current_user.update_attribute(:mixpanel_profile_updated, true)
  end

  def track_devices(declared_params)
    event = case route_method
            when 'POST'
              TrackingService::REGISTRATION
            when 'PATCH'
              declared_params[:registration_id].nil? ? TrackingService::DEACTIVATION : TrackingService::ACTIVATION
            else
              TrackingService::UNKNOWN
            end

    track(default_params(device_id: declared_params[:id]).merge(provider: declared_params[:provider]), event)
  end

  def track_phone_calls(declared_params)
    type = declared_params[:type]
    state = declared_params[:state]

    event = case route_method
            when 'POST'
              if type == 'incoming' && state == 'starting'
                TrackingService::INCOMING_CALL
              else
                TrackingService::OUTGOING_CALL
              end
            when 'GET'
              TrackingService::GET_CALL
            when 'PATCH'
              TrackingService::END_INCOMING_CALL
            else
              TrackingService::UNKNOWN
            end

    track(default_params(declared_params), event)
  end

  def track_sms_messages(declared_params)
    type = declared_params[:type]
    state = declared_params[:state]

    event = case route_method
            when 'POST'
              if type == 'incoming' && state == 'received'
                TrackingService::RECEIVED_SMS
              else
                TrackingService::OUTGOING_SMS
              end
            when 'GET'
              TrackingService::GET_SMS
            else
              TrackingService::UNKNOWN
            end

    track(default_params(declared_params), event)
  end

  def track_clipping(declared_params)
    event = case route_method
            when 'POST'
              TrackingService::CLIPPING
            when 'GET'
              TrackingService::GET_CLIPPING
            else
              TrackingService::UNKNOWN
            end
    track(default_params(declared_params), event)
  end

  private

  def route_method
    routes.first.route_method
  end

  def default_params(declared_params = {}, device_id = nil)
    declared_params ||= params # where does params comes from? is a kind of magic ...

    {
      email: @current_user.email,
      device_id: device_id || declared_params[:device_id]
    }
  end
end
