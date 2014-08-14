module API
  module Resources
    class Events < Grape::API
      resources :events do
        presenters = {
          IncomingSmsEvent => API::Entities::IncomingSmsEvent,
          IncomingCallEvent => API::Entities::IncomingCallEvent
        }

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

          type = params[:type]
          event_params = { identifier: params[:identifier], type: type, type => params[type].to_hash.symbolize_keys! }
          event_params = merge_access_token(event_params)
          event = CreateEvent.with(event_params)

          present event, with: presenters[event.class], as: :event
        end

        desc 'Get event.', ParamsHelper.auth_headers
        get do
          event = FindEvent.for(@current_token.token)
          present event, with: presenters[event.class], as: :event
        end
      end
    end
  end
end
