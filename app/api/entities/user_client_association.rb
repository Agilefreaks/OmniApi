require_relative 'timestamp_base_entity'

module API
  module Entities
    class UserClientAssociation < TimestampBaseEntity
      expose :client_name do |user_client_association, _options|
        user_client_association.client.name
      end

      expose :client_url do |user_client_association, _options|
        user_client_association.client.url
      end

      expose :client_id do |user_client_association, _options|
        user_client_association.client.id.to_s
      end

      expose :token do |user_client_association, _options|
        user_client_association.user.access_tokens.last.try(:token)
      end

      expose :scopes, using: API::Entities::Scope
    end
  end
end
