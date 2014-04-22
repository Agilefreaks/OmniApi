module API
  module Resources
    class Devices < Grape::API
      resources :devices do
        desc 'Register a device',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
          optional :name, type: String, desc: 'The name of the device.'
        end
        post '/' do
          authenticate!
          present Register.device(merged_params(params)), with: API::Entities::RegisteredDevice
        end

        desc 'Unregister a device.',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
        end
        route_param :identifier do
          delete '/' do
            authenticate!
            Unregister.device(merged_params(params))
          end
        end

        desc 'Activate.',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        params do
          requires :registration_id, type: String, desc: 'The registration id for the push notification service.'
          requires :identifier, type: String, desc: 'The unique device identifier.'
          optional :provider, type: Symbol, values: [:gcm], desc: 'The push notification provider'
        end
        put 'activate' do
          authenticate!
          present ActivateDevice.with(merged_params(params)), with: Entities::RegisteredDevice
        end

        desc 'Deactivate.',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        params do
          requires :identifier, type: String, desc: 'The unique device identifier.'
        end
        put 'deactivate' do
          authenticate!
          present DeactivateDevice.with(merged_params(params)), with: Entities::RegisteredDevice
        end
      end
    end
  end
end
