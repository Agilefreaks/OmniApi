shared_context :with_authenticated_web_client do
  include_context :with_authenticated_client

  let(:client) { ClientFactory.create_web_client }
end
