module API
  module Resources
    class Clippings < Grape::API
      resources :clippings do
        before do
          authenticate!
        end

        desc 'Create a clipping.', ParamsHelper.auth_headers
        params do
          requires :identifier, type: String, desc: 'Source device identifier.'
          requires :content, type: String, desc: 'Content for the clipping.'
        end
        post '/' do
          present CreateClipping.with(merged_params), with: API::Entities::Clipping
        end

        desc 'Get latest clipping.', ParamsHelper.auth_headers
        get '/last' do
          present FindClipping.for(@current_token.token), with: API::Entities::Clipping
        end
      end
    end
  end
end
