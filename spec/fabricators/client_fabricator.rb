Fabricator(:client)

Fabricator(:classified_add_client, from: :client) do
  after_create do |client, _transients|
    Fabricate(:access_token, client: client, scopes: ScopesRepository.get(:classified_add_client))
  end
end
