module API
  module Resources
    class Clippings < Grape::API
      resources :clippings do
        before do
          authenticate!
        end

        after do
          route_method = routes[0].route_method
          route_namespace = routes[0].route_namespace.tr('/', '')
          route_path = routes[0].route_path.split('/')[4]
          method = "#{route_method}_#{route_namespace}_#{route_path}".split('(')[0].downcase.chomp('_')
          params = { email: @current_user.email, identifier: merged_params[:identifier] }

          TrackingService.track_clippings(@current_user.email, method.to_sym, params)
        end

        desc 'Create a clipping.', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'Source device identifier.'
          requires :content, type: String, desc: 'Content for the clipping.'
        end
        post '/' do
          clipping = CreateClipping.with(merged_params)
          present clipping, with: API::Entities::Clipping
        end

        desc 'Get latest clipping.', ParamsHelper.omni_headers
        get '/last' do
          clipping = FindClipping.for(@current_token.token)
          present clipping, with: API::Entities::Clipping
        end
      end
    end
  end
end
