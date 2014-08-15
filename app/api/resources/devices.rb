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
          optional :provider,
                   type: Symbol,
                   values: [:gcm, :omni_sync],
                   desc: 'The push notification provider, it defaults to :gcm if none provided.'
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

        desc 'Get all registered devices for the user', ParamsHelper.auth_headers
        get do
          present @current_user.registered_devices, with: Entities::RegisteredDevice
        end

        desc 'Call the number.', ParamsHelper.auth_headers
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
        end
        post '/call' do
          Call.with(merged_params)
        end

        desc 'End an incoming call.', ParamsHelper.auth_headers
        post '/end_call' do
          EndCall.with(merged_params)
        end

        desc 'Send sms.', ParamsHelper.auth_headers
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
          requires :content, type: String, desc: 'The content of the sms.'
        end
        post '/sms' do
          Sms.with(merged_params)
        end
      end
    end
  end
end
