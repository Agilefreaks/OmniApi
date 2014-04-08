class GenerateOauthToken
  def self.for(env)
    GenerateOauthToken.new.execute(env)
  end

  def execute(env)
    Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.verify(req.client_id)
      req.invalid_client! unless client

      authorization_class = GenerateOauthToken.const_get(classify(req.grant_type))
      res.access_token = authorization_class.create(client, req).to_bearer_token(:with_refresh_token)
    end.call(env)
  end

  def classify(symbol)
    symbol.to_s.split('_').map(&:capitalize).join
  end

  def self.build_access_token_for(access_tokens_holder, client_id = nil)
    access_token = AccessToken.build(client_id)
    access_token.refresh_token = ::RefreshToken.build(client_id)
    access_tokens_holder.access_tokens.push(access_token)
    access_tokens_holder.save

    access_token
  end

  class AuthorizationCode
    def self.create(client, req)
      user = User.find_by_code(req.code)
      req.invalid_grant! unless user

      # remove authorization code
      user.invalidate_authorization_code(req.code)

      GenerateOauthToken.build_access_token_for(user, client.id)
    end
  end

  class RefreshToken
    def self.create(client, req)
      user = User.find_by_token(req.refresh_token)
      req.invalid_grant! unless user

      token = user.access_tokens.where('refresh_token.token' => req.refresh_token).first
      token.update_attribute(:expires_at, token.expires_at + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME)
      token
    end
  end

  class ClientCredentials
    def self.create(client, req)
      req.invalid_grant! unless client.secret == req.client_secret

      GenerateOauthToken.build_access_token_for(client)
    end
  end
end
