module Concerns
  module OAuth2Token
    extend ActiveSupport::Concern

    DEFAULT_EXPIRATION_TIME = 1.month

    included do
      field :token, type: String
      field :expires_at, type: Date
      field :client_id, type: BSON::ObjectId
    end

    module ClassMethods
      def build(client_id, bytes = 64)
        builder_token = new
        builder_token.token = SecureRandom.base64(bytes)
        builder_token.client_id = client_id
        builder_token.expires_at = Date.current + DEFAULT_EXPIRATION_TIME
        builder_token
      end
    end
  end
end
