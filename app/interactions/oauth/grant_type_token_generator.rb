module Oauth
  class GrantTypeTokenGenerator < Oauth::BaseDelegatingTokenGenerator
    protected

    def self.delegate_generator_class(req)
      Oauth.const_get("#{classify(req.grant_type)}TokenGenerator")
    end
  end
end