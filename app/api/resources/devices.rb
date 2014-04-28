module API
  module Resources
    class Devices < Grape::API
      resources :devices do
        before do
          authenticate!
        end

        desc 'Register a device', ParamsHelper.auth_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
          optional :name, type: String, desc: 'The name of the device.'
        end
        post '/' do
          present Register.device(merged_params), with: API::Entities::RegisteredDevice
        end

        desc 'Unregister a device.', ParamsHelper.auth_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
        end
        route_param :identifier do
          delete '/' do
            Unregister.device(merged_params)
          end
        end

        desc 'Activate.', ParamsHelper.auth_headers
        params do
          requires :registration_id, type: String, desc: 'The registration id for the push notification service.'
          requires :identifier, type: String, desc: 'The unique device identifier.'
          optional :provider, type: Symbol, values: [:gcm, :omni_sync], desc: 'The push notification provider'
        end
        put 'activate' do
          present ActivateDevice.with(merged_params), with: Entities::RegisteredDevice
        end

        desc 'Deactivate.', ParamsHelper.auth_headers
        params do
          requires :identifier, type: String, desc: 'The unique device identifier.'
        end
        put 'deactivate' do
          present DeactivateDevice.with(merged_params), with: Entities::RegisteredDevice
        end
      end
    end
  end
end
