Fabricator(:contact) do
  contact_id { sequence(:contact_id) { |i| i.to_s } }
end