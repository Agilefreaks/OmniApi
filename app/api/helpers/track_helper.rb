module TrackHelper
  extend Grape::API::Helpers

  def track(extra_params = {})
    default_params =
      {
        email: @current_user.email,
        device_type: params[:provider],
        identifier: params[:identifier]
      }

    TrackingService.track(@current_user.email, method_name(routes).to_sym, default_params.merge(extra_params))
  end

  def method_name(routes = [])
    extra_route_settings = routes[0].route_settings[:extra]

    route_method = routes[0].route_method
    route_namespace = routes[0].route_namespace.split(':')[0].tr('/', '')
    route_action = extra_route_settings[:action] unless extra_route_settings.nil?

    "#{route_method}_#{route_namespace}_#{route_action}".split('(')[0].downcase.chomp('_')
  end
end
