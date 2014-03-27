module Concerns
  module OAuth2Token
    extend ActiveSupport::Concern

    DEFAULT_EXPIRATION_TIME = 1.month

    included do
      field :token, type: String
      field :expires_in, type: Integer
    end

    module ClassMethods
      def build(token = nil, bytes = 64)
        builder_token = new
        builder_token.token = token || SecureRandom.base64(bytes)
        builder_token.expires_in = DEFAULT_EXPIRATION_TIME
        builder_token
      end
    end
  end
end
