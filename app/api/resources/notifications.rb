module API
  module Resources
    class Notifications < Grape::API
      before do
        authenticate!
      end

      desc 'Create a notification', ParamsHelper.auth_headers
      params do
        requires :identifier, type: String, desc: 'Unique device identifier.'
        requires :type, type: Symbol, values: [:incoming_call, :incoming_sms]
        optional :incoming_call, type: Hash do
          optional :phone_number, type: String, desc: 'The source phone number.'
        end
      end
      resources :notifications do
        post '/' do
          present CreateNotification.with(merged_params), with: API::Entities::Notification
        end
      end
    end
  end
end
