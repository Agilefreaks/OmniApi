class ScopesRepository
  DESCRIPTION = {
    authorization_codes_create: 'Can create authorization codes.',
    users_create: 'Can create users',
    authorization_codes_get: 'Can fetch auth codes.',
    phone_calls_create: 'Initiate phone calls.'
  }

  GROUPS = {
    web_client: [:authorization_codes_create, :users_create],
    android_client: [:authorization_codes_get],
    classified_add_client: [:phone_calls_create]
  }

  def self.description(scope)
    DESCRIPTION[scope]
  end

  def self.get(group)
    GROUPS[group] || []
  end
end
