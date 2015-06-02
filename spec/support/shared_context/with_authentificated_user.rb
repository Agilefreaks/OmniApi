shared_context :with_authenticated_user do
  let(:user) { Fabricate(:user) }
  let(:access_token) { AccessToken.build }

  # rubocop:disable Blocks
  let(:options) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "bearer #{access_token.token}"
    }
  end

  before do
    user.access_tokens.push(access_token)
    user.save
  end
end
