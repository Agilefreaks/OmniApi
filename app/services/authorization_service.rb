class AuthorizationService
  def self.verify(resource, method, token)
    role = (resource.to_s + '_' + method.to_s).to_sym
    fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless token.roles && token.roles.include?(role)
  end
end
