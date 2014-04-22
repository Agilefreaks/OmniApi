module API
  module Resources
    class Clippings < Grape::API
      resources :clippings do
        desc 'Create a clipping.',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        params do
          requires :identifier, type: String, desc: 'Source device identifier.'
          requires :content, type: String, desc: 'Content for the clipping.'
        end
        post '/' do
          authenticate!
          present CreateClipping.with(merged_params), with: API::Entities::Clipping
        end

        desc 'Get latest clipping.',
             headers: {
               'Authorization' => {
                 description: 'The authorization token.',
                 required: true
               }
             }
        get '/last' do
          authenticate!
          present FindClipping.for(@current_token.token), with: API::Entities::Clipping
        end
      end
    end
  end
end
