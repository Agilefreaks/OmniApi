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

        after do
          route_method = routes[0].route_method
          route_namespace = routes[0].route_namespace.tr('/', '')
          route_path = routes[0].route_path.split('/')[4]
          method = "#{route_method}_#{route_namespace}_#{route_path}".split('(')[0].downcase.chomp('_')
          TrackingService.send(
            method.to_sym,
            email: @current_user.email,
            params: merged_params) if TrackingService.respond_to? method
        end

        desc 'Create a event.', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'Unique device identifier.'
          requires :type, type: Symbol, values: [:incoming_call, :incoming_sms]
          optional :incoming_call, type: Hash do
            optional :phone_number, type: String, desc: 'The source phone number.'
            optional :contact_name, type: String, desc: 'The name of the contact.'
          end
          optional :incoming_sms, type: Hash do
            optional :phone_number, type: String, desc: 'The source phone number.'
            optional :content, type: String, desc: 'The content of the sms.'
            optional :contact_name, type: String, desc: 'The name of the contact.'
          end
        end
        post '/' do
          type = params[:type]
          event_params = { identifier: params[:identifier], type: type, type => params[type].to_hash.symbolize_keys! }
          event_params = merge_access_token(event_params)
          event = CreateEvent.with(event_params)

          present event, with: presenters[event.class], as: :event
        end

        desc 'Get event.', ParamsHelper.omni_headers
        get do
          event = FindEvent.for(@current_token.token)
          present event, with: presenters[event.class], as: :event
        end
      end
    end
  end
end
