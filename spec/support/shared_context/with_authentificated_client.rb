shared_context :with_authentificated_client do
  let(:client) { Fabricate(:client) }
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
    client.access_tokens.push(access_token)
    client.save
  end
end
