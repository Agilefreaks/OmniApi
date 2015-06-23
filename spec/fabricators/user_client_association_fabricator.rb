Fabricator(:user_client_association) do
  client { Fabricate(:client) }
  user { Fabricate(:user) }
end
