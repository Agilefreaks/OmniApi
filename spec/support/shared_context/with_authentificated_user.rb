shared_context :with_authentificated_user do
  let(:user) { Fabricate(:user) }
  let(:access_token) { AccessToken.build }

  before do
    user.access_tokens.push(access_token)
    user.save
  end
end