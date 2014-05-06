class UserFactory
  def create(client, params)
    user = User.create(params)
    GenerateOauthToken.build_access_token_for(user, client.id)

    user
  end
end
