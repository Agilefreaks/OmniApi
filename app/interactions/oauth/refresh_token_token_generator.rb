module Oauth
  class RefreshTokenTokenGenerator < Oauth::BaseDelegatingTokenGenerator
    DEFAULT_RESOURCE_TYPE = 'user'

    protected

    def self.delegate_generator_class(req)
      resource_type = req.params['resource_type'].blank? ? DEFAULT_RESOURCE_TYPE : req.params['resource_type']
      Oauth.const_get("RefreshToken#{classify(resource_type)}TokenGenerator")
    end
  end
end