module AuthenticationHelper
  def require_oauth_token
    @current_token = request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
    fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_token
  end

  def authenticate!
    require_oauth_token
    @current_user = User.find_by_token(@current_token.token)
    fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_user
  end
end