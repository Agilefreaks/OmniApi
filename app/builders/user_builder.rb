class UserBuilder
  def build(client, params)
    50.percent_of_the_time do
      params[:via_omnipaste] = false
    end

    user = User.create(params)
    GenerateOauthToken.build_access_token_for(user, client.id)

    user
  end
end
