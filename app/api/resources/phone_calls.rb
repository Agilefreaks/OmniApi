module API
  module Resources
    class PhoneCalls < Grape::API
      resources :phone_calls do
        before do
          authenticate!
        end

        after do
          track
        end

        helpers do
          params :shared do
            optional :device_id,
                     type: String,
                     desc: 'Device id. Can be the source device id or
                            the target device id, depending on the value of @state'
            optional :number, type: String, desc: 'The phone number.'
            optional :contact_name, type: String, desc: 'Contact name.'
            optional :state,
                     values: [:initiate, :end_call, :hold, :incoming],
                     default: :end_call,
                     type: Symbol,
                     desc: 'State of the call.'
          end
        end

        desc 'Create a phone call.', ParamsHelper.omni_headers
        params do
          use :shared
        end
        post do
          present Call.with(merged_params), with: API::Entities::PhoneCall
        end

        desc 'Patch a call.', ParamsHelper.omni_headers
        params do
          requires :id, type: String, desc: 'The phone call id.'
          use :shared
        end
        route_param :id do
          patch do
            present EndCall.with(merged_params(false)), with: API::Entities::PhoneCall
          end
        end

        desc 'Get a phone call.', ParamsHelper.omni_headers
        params do
          requires :id, type: String, desc: 'The phone call id.'
        end
        route_param :id do
          get do
            present @current_user.phone_calls.find(declared_params[:id]), with: API::Entities::PhoneCall
          end
        end
      end
    end
  end
end
