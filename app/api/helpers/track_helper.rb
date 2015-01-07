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
    route_method = routes[0].route_method
    route_namespace = routes[0].route_namespace.tr('/', '')
    route_path = routes[0].route_path.split('/')[4]

    "#{route_method}_#{route_namespace}_#{route_path}".split('(')[0].downcase.chomp('_')
  end
end
