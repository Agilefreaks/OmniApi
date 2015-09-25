module Oauth
  class RefreshTokenTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(_client, req)
      @token = find_token(req)
      super
    end

    def self.generate_core(_client, _req)
      @token.update_attribute(:expires_at, Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME)
      @token
    end

    def self.authorize!(_client, req)
      req.invalid_grant! unless @token
    end

    def self.find_token(req)
      user = User.find_by_token(req.refresh_token)
      user.access_tokens.where('refresh_token.token' => req.refresh_token).first if user
    end
  end
end
