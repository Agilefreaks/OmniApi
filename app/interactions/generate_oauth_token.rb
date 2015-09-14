class GenerateOauthToken
  def self.for(env)
    GenerateOauthToken.new.execute(env)
  end

  def execute(env)
    Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.verify(req.client_id)
      req.invalid_client! unless client
      res.access_token = Oauth::GrantTypeTokenGenerator.generate(client, req).to_bearer_token(:with_refresh_token)
    end.call(env)
  end
end
