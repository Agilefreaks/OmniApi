require_relative 'base_token_generator'

module Oauth
  class BaseRefreshTokenTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(_client, req)
      @token = find_token(req)
      super
    end

    def self.find_token(_req)
      fail NotImplementedError
    end

    def self.generate_core(_client, _req)
      @token.update_attribute(:expires_at, Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME)
      @token
    end

    def self.authorize!(_client, req)
      req.invalid_grant! unless @token
    end
  end
end
