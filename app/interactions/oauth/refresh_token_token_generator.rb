module Oauth
  class RefreshTokenTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(client, req)
      @user = find_user(req)
      super
    end

    protected

    def self.find_user(req)
      User.find_by_token(req.refresh_token)
    end

    def self.generate_core(_, req)
      token = @user.access_tokens.where('refresh_token.token' => req.refresh_token).first
      token.update_attribute(:expires_at, Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME)
      token
    end

    def self.authorize!(_, req)
      req.invalid_grant! unless @user
    end
  end
end