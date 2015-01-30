module TrackHelper
  extend Grape::API::Helpers

  def track(extra_params = {})
    default_params =
      {
        email: @current_user.email,
        device_type: params[:provider],
        identifier: params[:identifier]
      }

    TrackingService.track(@current_user.email, get_route_name(routes[0]).to_sym, default_params.merge(extra_params))
  end

  def get_route_name(current_route)
    custom_route_settings = current_route.route_settings[:custom]

    route_method = current_route.route_method
    route_namespace = current_route.route_namespace.split(':')[0].tr('/', '')
    route_action = custom_route_settings[:action] unless custom_route_settings.nil?

    "#{route_method}_#{route_namespace}_#{route_action}".split('(')[0].downcase.chomp('_')
  end
end
