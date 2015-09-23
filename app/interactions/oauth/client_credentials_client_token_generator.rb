require_relative 'base_client_credentials_token_generator'

module Oauth
  class ClientCredentialsClientTokenGenerator < Oauth::BaseClientCredentialsTokenGenerator
    def self.generate_core(client, _)
      build_access_token_for(client)
    end
  end
end
