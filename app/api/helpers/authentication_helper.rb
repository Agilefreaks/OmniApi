module AuthenticationHelper
  def require_oauth_token
    @current_token = request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]

    NewRelic::Agent.add_custom_parameters(request.env) unless @current_token
    fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_token
  end

  def authenticate!
    require_oauth_token
    @current_user = User.find_by_token(@current_token.token)

    unless @current_user
      NewRelic::Agent.add_custom_parameters(request.env)
      fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized
    end

    NewRelic::Agent.add_custom_parameters(user_email: @current_user.email)
    @current_token = @current_user.access_tokens.find_by(token: @current_token.token)
  end

  def authenticate_client!
    require_oauth_token
    @current_client = Client.find_by_token(@current_token.token)

    unless @current_client
      NewRelic::Agent.add_custom_parameters(request.env)
      fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized
    end

    NewRelic::Agent.add_custom_parameters(client_name: @current_client.name)
    @current_token = @current_client.access_tokens.find_by(token: @current_token.token)
  end

  def authenticate_user_or_client!
    begin
      authenticate!
    rescue Rack::OAuth2::Server::Resource::Bearer::Unauthorized
      authenticate_client!
    end
  end
end
