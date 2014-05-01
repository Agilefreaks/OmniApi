shared_context :with_authentificated_user do
  let(:user) { Fabricate(:user) }
  let(:access_token) { AccessToken.build }

  # rubocop:disable Blocks
  let(:options) {
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "bearer #{access_token.token}"
    }
  }

  before do
    user.access_tokens.push(access_token)
    user.save
  end
end
