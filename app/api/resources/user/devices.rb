module API
  module Resources
    module User
      class Devices < Grape::API
        resources :devices do
          before do
            authenticate!
          end

          after do
            track_devices(declared_params)
          end

          helpers do
            params :shared do
              optional :name, type: String, desc: 'The name of the device.'
              optional :registration_id, type: String, desc: 'The registration id.'
              optional :provider,
                       type: Symbol,
                       values: [:gcm, :omni_sync],
                       desc: 'The push notification provider, it defaults to :gcm if none provided.'
              optional :public_key, type: String, desc: 'The public key.'
            end
          end

          desc 'Create a device', ParamsHelper.omni_headers
          params do
            use :shared
          end
          post '/' do
            device = DeviceBuilder.new.build(@current_token.token, merge_client_version(declared_params))
            present device, with: API::Entities::Device
          end

          desc 'Get a device.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'Device id.'
          end
          route_param :id do
            get do
              present @current_user.devices.find(declared_params[:id]), with: API::Entities::Device
            end
          end

          desc 'Get all devices.', ParamsHelper.omni_headers
          get do
            present @current_user.devices, with: API::Entities::Device
          end

          desc 'Delete a device.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'Device id.'
          end
          route_param :id do
            delete do
              @current_user.devices.find(declared_params[:id]).delete
            end
          end

          desc 'Update existing device.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'Device id.'
            use :shared
          end
          route_param :id do
            put do
              device = @current_user.devices.find(declared_params[:id])
              device.update_attributes(declared_params)

              present device, with: API::Entities::Device
            end
          end

          desc 'Patch an existing device.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'Device id.'
            use :shared
          end
          route_param :id do
            patch do
              device = @current_user.devices.find(declared_params[:id])
              device.update_attributes(declared_params(false))

              present device, with: API::Entities::Device
            end
          end
        end
      end
    end
  end
end
