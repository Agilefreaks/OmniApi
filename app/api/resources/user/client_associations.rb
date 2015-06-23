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

            present CreateUserClientAssociation.between(@current_user, client), with: API::Entities::UserClientAssociation
          end
        end
      end
    end
  end
end
