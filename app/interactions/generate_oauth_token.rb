class GenerateOauthToken
  def self.for(env)
    GenerateOauthToken.new.execute(env)
  end

  def execute(env)
    Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.verify(req.client_id)
      req.invalid_client! unless client

      authorization_class = GenerateOauthToken.const_get(classify(req.grant_type))
      res.access_token = authorization_class.create(client, req).to_bearer_token(true)
    end.call(env)
  end

  def classify(symbol)
    symbol.to_s.split('_').map(&:capitalize).join
  end

  class AuthorizationCode
    def self.create(client, req)
      user = User.find_by_code(req.code)
      req.invalid_grant! unless user

      access_token = AccessToken.build
      user.access_tokens.push(access_token)
      user.save

      access_token
    end
  end

  class RefreshToken
    def self.create(client, req)
      req.invalid_grant! unless ::RefreshToken.verify(req.refresh_token)
      AccessToken.build
    end
  end

  class ClientCredentials
    def self.create(client, req)
      req.invalid_grant! unless client.secret == req.client_secret

      access_token = AccessToken.build
      client.access_tokens.push(access_token)
      client.save

      access_token
    end
  end
end
