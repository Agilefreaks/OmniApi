Fabricator(:access_token) do
  token { SecureRandom.base64(64) }
  expires_at { Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME }
end
