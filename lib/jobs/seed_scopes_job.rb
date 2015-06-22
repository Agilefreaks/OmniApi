class SeedScopesJob
  AVAILABLE_SCOPES = [
      {key: :phone_calls_create, description: 'Start phone calls'}
  ]

  def perform
    AVAILABLE_SCOPES.each do |scope_data|
      scope = Scope.where(key: scope_data[:key]).first

      scope = Scope.create(key: scope_data[:key]) unless scope.present?
      scope.update_attributes!(description: scope_data[:description])
    end
  end
end