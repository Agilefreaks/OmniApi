module API
  module Resources
    module User
      class ClientAssociations < Grape::API
        resources :client_associations do
          before { authenticate! }

          desc 'Associate a Client with User', ParamsHelper.omni_headers
          params do
            requires :client_id, type: String, desc: 'Id of the client.'
          end
          post do
            client = Client.find(merged_params[:client_id])
            association = CreateUserClientAssociation.between(@current_user, client)

            present association, with: API::Entities::UserClientAssociation
          end

          desc 'Get Client Association for a client', ParamsHelper.omni_headers
          params do
            requires :client_id, type: String, desc: 'Id of the client.'
          end
          route_param :client_id do
            get do
              association = UserClientAssociation.find_by(client_id: merged_params[:client_id], user_id: @current_user.id)
              present association, with: API::Entities::UserClientAssociation
            end
          end
        end
      end
    end
  end
end
