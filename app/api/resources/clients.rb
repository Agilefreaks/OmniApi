module API
  module Resources
    class Clients < Grape::API
      resource :clients do
        before { authenticate! }

        desc 'Get client information.', ParamsHelper.omni_headers
        params do
          requires :id, type: String, desc: 'Id of the client.'
        end
        route_param :id do
          get do
            client = Client.find(merged_params[:id])
            present client, with: API::Entities::Client
          end
        end
      end
    end
  end
end
