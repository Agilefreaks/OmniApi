class ScopesRepository
  GROUPS = {
    web_client: [:authorization_codes_create, :users_create],
    android_client: [:authorization_codes_get],
    omnikiq_client: [:sms_messages_update]
  }

  def self.get(group)
    GROUPS[group] || []
  end
end
