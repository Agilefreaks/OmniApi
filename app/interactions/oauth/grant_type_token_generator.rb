require_relative 'base_delegating_token_generator'

module Oauth
  class GrantTypeTokenGenerator < Oauth::BaseDelegatingTokenGenerator
    def self.delegate_generator_class(req)
      Oauth.const_get("#{classify(req.grant_type)}TokenGenerator")
    end
  end
end
