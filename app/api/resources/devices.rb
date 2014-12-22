module API
  module Resources
    class Devices < Grape::API
      resources :devices do
        before do
          authenticate!
        end

        after do
          route_method = routes[0].route_method
          route_namespace = routes[0].route_namespace.tr('/', '')
          route_path = routes[0].route_path.split('/')[4]
          method = "#{route_method}_#{route_namespace}_#{route_path}".split('(')[0].downcase.chomp('_')
          params =
            {
              email: @current_user.email,
              device_type: merged_params[:provider],
              identifier: merged_params[:identifier]
            }

          TrackingService.track_devices(@current_user.email, method.to_sym, params)
        end

        desc 'Create a device', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
          optional :name, type: String, desc: 'The name of the device.'
          optional :public_key, type: String, desc: 'The public key of the device.'
        end
        post '/' do
          register_device = Register.device(merged_params)

          unless register_device.valid?
            error!(register_device.errors.full_messages, '400')
          end

          present register_device, with: API::Entities::RegisteredDevice
        end

        desc 'Delete a device.', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
        end
        delete '/' do
          Unregister.device(merged_params)
        end

        desc 'Activate.', ParamsHelper.omni_headers
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

        desc 'Deactivate.', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'The unique device identifier.'
        end
        put 'deactivate' do
          present DeactivateDevice.with(merged_params), with: Entities::RegisteredDevice
        end

        desc 'Update existing device', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'The unique device identifier.'
          optional :name, type: String, desc: 'The name of the device.'
          optional :public_key, type: String, desc: 'The devices public key.'
        end
        put '/' do
          rd = @current_user.registered_devices.find_by(identifier: declared_params[:identifier])
          rd.update_attributes(declared_params)

          present rd, with: Entities::RegisteredDevice
        end

        desc 'Get registered devices for the user', ParamsHelper.omni_headers
        params do
          optional :identifier, desc: 'If this is provided we will only return this device'
        end
        get do
          identifier = merged_params[:identifier]
          result = if identifier.nil?
                     @current_user.registered_devices
                   else
                     @current_user.registered_devices.find_by(identifier: identifier)
                   end

          present result, with: Entities::RegisteredDevice
        end

        desc 'Call the number.', ParamsHelper.omni_headers
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
        end
        post '/call' do
          Call.with(merged_params)
        end

        desc 'End an incoming call.', ParamsHelper.omni_headers
        post '/end_call' do
          EndCall.with(merged_params)
        end

        desc 'Send sms.', ParamsHelper.omni_headers
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
          requires :content, type: String, desc: 'The content of the sms.'
        end
        post '/sms' do
          SendSmsMessage.with(merged_params)
        end
      end
    end
  end
end
