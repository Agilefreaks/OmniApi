module API
  module Resources
    module V2
      class Devices < Grape::API
        resources :devices do
          before do
            authenticate!
          end

          after do
            params =
              {
                email: @current_user.email,
                device_type: merged_params[:provider],
                identifier: merged_params[:identifier]
              }

            TrackingService.track(@current_user.email, RouteHelper.method_name(routes).to_sym, params)
          end

          desc 'Create a device', ParamsHelper.omni_headers
          params do
            optional :name, type: String, desc: 'The name of the device.'
            optional :public_key, type: String, desc: 'The public key of the device.'
          end
          post '/' do
          end
        end
      end
    end
  end
end
