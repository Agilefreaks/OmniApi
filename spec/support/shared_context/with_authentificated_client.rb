shared_context :with_authenticated_client do
  let(:client) { Fabricate(:client) }
  let(:access_token) { client.access_tokens.first }

  # rubocop:disable Blocks
  let(:options) {
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "bearer #{access_token.token}"
    }
  }
end
