shared_context :with_authenticated_web_client do
  include_context :with_authenticated_client

  let(:access_token) { AccessToken.build(roles: RolesRepository.get(:web_client)) }

end
