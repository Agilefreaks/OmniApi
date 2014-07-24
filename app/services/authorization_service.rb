class AuthorizationService
  def self.verify(resource, method, token)
    scope = (resource.to_s + '_' + method.to_s).to_sym
    fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless token.scopes && token.scopes.include?(scope)
  end
end
