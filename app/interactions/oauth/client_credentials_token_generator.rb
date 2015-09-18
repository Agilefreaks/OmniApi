require_relative 'base_delegating_token_generator'

module Oauth
  class ClientCredentialsTokenGenerator < Oauth::BaseDelegatingTokenGenerator
    DEFAULT_RESOURCE_TYPE = 'client'

    protected

    def self.delegate_generator_class(req)
      resource_type = req.params['resource_type'].blank? ? DEFAULT_RESOURCE_TYPE : req.params['resource_type']
      Oauth.const_get("ClientCredentials#{classify(resource_type)}TokenGenerator")
    end
  end
end