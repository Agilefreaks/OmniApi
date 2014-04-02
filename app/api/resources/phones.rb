module WebOmni
  module Resources
    class Phones < Grape::API
      resources :phones do
        desc 'Call the number.', {
          headers: {
            :'Channel' => {
              description: 'The channel, usually the users email address',
              required: true
            }
          }
        }
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
        end
        post '/call' do
          authenticate!
          Call.with(call_params)
        end
      end
    end
  end
end
