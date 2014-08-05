module API
  module Resources
    class Events < Grape::API
      resources :events do
        before do
          authenticate!
        end

        desc 'Create a event.', ParamsHelper.auth_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
          requires :type, type: Symbol, values: [:incoming_call, :incoming_sms]
          optional :incoming_call, type: Hash do
            optional :phone_number, type: String, desc: 'The source phone number.'
          end
          optional :incoming_sms, type: Hash do
            optional :phone_number, type: String, desc: 'The source phone number.'
            optional :content, type: String, desc: 'The content of the sms.'
          end
        end
        post '/' do
          present CreateEvent.with(merged_params), with: API::Entities::Event
        end

        desc 'Get event.', ParamsHelper.auth_headers
        get do
          present FindEvent.for(@current_token.token), with: API::Entities::Event
        end
      end
    end
  end
end
