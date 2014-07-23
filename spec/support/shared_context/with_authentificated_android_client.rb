shared_context :with_authenticated_android_client do
  include_context :with_authenticated_client

  let(:client) { ClientFactory.create_android_client }
end
