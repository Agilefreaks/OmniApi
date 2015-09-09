require_relative 'base_client_credentials_token_generator'

module Oauth
  class ClientCredentialsUserTokenGenerator < Oauth::BaseClientCredentialsTokenGenerator
    protected

    def self.generate_core(client, req)
      user = User.find_by(email: req.params['resource_id'])
      build_access_token_for(user, client.id)
    end
  end
end
