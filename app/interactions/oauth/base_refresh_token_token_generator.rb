require_relative 'base_token_generator'

module Oauth
  class BaseRefreshTokenTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(client, req)
      @token = find_token(req)
      super
    end

    protected

    def self.find_token(req)
      raise NotImplementedError
    end

    def self.generate_core(_, req)
      @token.update_attribute(:expires_at, Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME)
      @token
    end

    def self.authorize!(_, req)
      req.invalid_grant! unless @token
    end
  end
end
