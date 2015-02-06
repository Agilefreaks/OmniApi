Fabricator(:user) do
  email { Faker::Internet.safe_email }
end
