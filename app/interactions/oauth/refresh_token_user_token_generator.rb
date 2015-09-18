module Oauth
  class RefreshTokenUserTokenGenerator < BaseRefreshTokenTokenGenerator
    protected

    def self.find_token(req)
      user = User.find_by_token(req.refresh_token)
      user.access_tokens.where('refresh_token.token' => req.refresh_token).first if user
    end
  end
end