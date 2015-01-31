module TrackHelper
  extend Grape::API::Helpers

  def track(params, event = nil)
    event ||= get_route_name(routes[0]).to_sym

    TrackingService.track(@current_user.email, event, params)
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

    track(default_params(device_id: declared_params[:id]), event)
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

  def get_route_name(current_route)
    custom_route_settings = current_route.route_settings[:custom]

    route_method = current_route.route_method
    route_namespace = current_route.route_namespace.split(':')[0].tr('/', '')
    route_action = custom_route_settings[:action] unless custom_route_settings.nil?

    "#{route_method}_#{route_namespace}_#{route_action}".split('(')[0].downcase.chomp('_')
  end

  private

  def route_method
    routes.first.route_method
  end

  def default_params(declared_params = {}, device_id = nil)
    declared_params ||= params # where does params comes from? is a kind of magic ...

    {
      email: @current_user.email,
      device_type: declared_params[:provider],
      device_id: device_id || declared_params[:device_id]
    }
  end
end
