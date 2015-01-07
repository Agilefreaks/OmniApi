module API
  module Resources
    class Clippings < Grape::API
      resources :clippings do
        before do
          authenticate!
        end

        after do
          track
        end

        desc 'Create a clipping.', ParamsHelper.omni_headers
        params do
          requires :identifier, type: String, desc: 'Source device identifier.'
          requires :content, type: String, desc: 'Content for the clipping.'
        end
        post '/' do
          clipping = CreateClipping.with(merged_params)
          present clipping, with: API::Entities::Clipping
        end

        desc 'Get latest clipping.', ParamsHelper.omni_headers
        get '/last' do
          clipping = FindClipping.for(@current_token.token)
          present clipping, with: API::Entities::Clipping
        end
      end
    end
  end
end
