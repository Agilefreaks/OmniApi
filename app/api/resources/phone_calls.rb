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
            optional :state, values: [:initiate, :end_call, :hold, :incoming], type: Symbol, desc: 'State of the call.'
          end
        end

        desc 'Call the number.', ParamsHelper.omni_headers
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
          optional :device_id, type: String, desc: 'Target device id.'
          use :shared
        end
        post do
          present Call.with(merged_params), with: API::Entities::PhoneCall
        end

        desc 'Patch a call.'
        params do
          requires :id, type: String, desc: 'The phone call id.'
          use :shared
        end
        route_param :id do
          patch do
            present EndCall.with(merged_params(false)), with: API::Entities::PhoneCall
          end
        end
      end
    end
  end
end
