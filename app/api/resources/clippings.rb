module API
  module Resources
    class Clippings < Grape::API
      resources :clippings do
        before do
          authenticate!
        end

        after do
          track_clipping(declared_params)
        end

        desc 'Create a clipping.', ParamsHelper.omni_headers
        params do
          optional :device_id, type: String, desc: 'Id for source device.'
          optional :identifier, type: String, desc: 'Source device identifier.'
          at_least_one_of :device_id, :identifier
          requires :content, type: String, desc: 'Content for the clipping.'
        end
        post '/' do
          clipping = CreateClipping.with(merged_params(false))
          present clipping, with: API::Entities::Clipping
        end

        desc 'Deprecated, use get with :id. Get latest clipping.', ParamsHelper.omni_headers
        get '/last' do
          clipping = FindClipping.for(@current_token.token)
          present clipping, with: API::Entities::Clipping
        end

        desc 'Get clipping.', ParamsHelper.omni_headers
        params do
          requires :id, type: String, desc: 'Id of the clipping.'
        end
        route_param :id do
          get do
            clipping = @current_user.clippings.find(merged_params[:id])
            present clipping, with: API::Entities::Clipping
          end
        end
      end
    end
  end
end
