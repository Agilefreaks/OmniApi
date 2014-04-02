module API
  module Resources
    class Phones < Grape::API
      resources :phones do
        desc 'Call the number.', {
          headers: {
            :'Authorization' => {
              description: 'The authorization token.',
              required: true
            }
          }
        }
        params do
          requires :phone_number, type: String, desc: 'The phone number to dial.'
        end
        post '/call' do
          authenticate!
          Call.with(merged_params(params))
        end
      end
    end
  end
end
