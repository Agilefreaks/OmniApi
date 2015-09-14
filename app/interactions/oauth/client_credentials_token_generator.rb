require_relative 'base_delegating_token_generator'

module Oauth
  class ClientCredentialsTokenGenerator < Oauth::BaseDelegatingTokenGenerator
    protected

    def self.delegate_generator_class(req)
      Oauth.const_get("ClientCredentials#{classify(req.params['resource_type'])}TokenGenerator")
    end
  end
end