module API
  module Resources
    class Phones < Grape::API
      resources :phones do
        before do
          authenticate!
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
      end
    end
  end
end
