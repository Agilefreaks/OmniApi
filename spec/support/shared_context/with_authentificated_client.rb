shared_context :with_authentificated_client do
  let(:client) { Fabricate(:client) }
  let(:access_token) { AccessToken.build }

  before do
    client.access_tokens.push(access_token)
    client.save
  end
end
