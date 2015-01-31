module TrackHelper
  extend Grape::API::Helpers

  def track(extra_params = {}, event = nil)
    default_params =
      {
        email: @current_user.email,
        device_type: params[:provider],
        device_id: params[:id]
      }

    event ||= get_route_name(routes[0]).to_sym

    TrackingService.track(@current_user.email, event, default_params.merge(extra_params))
  end

  def track_devices(declared_params)
    route_method = routes.first.route_method

    case route_method
    when 'POST'
      event = TrackingService::REGISTRATION_EVENT
    when 'PATCH'
      event = declared_params[:registration_id].nil? ? TrackingService::DEACTIVATION_EVENT : TrackingService::ACTIVATION_EVENT
    else
      event = TrackingService::UNKNOWN
    end

    track({}, event)
  end

  def get_route_name(current_route)
    custom_route_settings = current_route.route_settings[:custom]

    route_method = current_route.route_method
    route_namespace = current_route.route_namespace.split(':')[0].tr('/', '')
    route_action = custom_route_settings[:action] unless custom_route_settings.nil?

    "#{route_method}_#{route_namespace}_#{route_action}".split('(')[0].downcase.chomp('_')
  end
end
