class ScopesRepository
  GROUPS = {
    web_client: [:authorization_codes_create, :users_create],
    android_client: [:authorization_codes_get]
  }

  def self.get(group)
    GROUPS[group] || []
  end
end
