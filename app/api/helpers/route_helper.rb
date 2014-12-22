module RouteHelper
  def method_name(routes = [])
    route_method = routes[0].route_method
    route_namespace = routes[0].route_namespace.tr('/', '')
    route_path = routes[0].route_path.split('/')[4]
    method = "#{route_method}_#{route_namespace}_#{route_path}".split('(')[0].downcase.chomp('_')

    method
  end

  module_function :method_name
end