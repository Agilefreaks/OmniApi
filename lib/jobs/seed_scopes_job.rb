class SeedScopesJob
  AVAILABLE_SCOPES = [
      {key: :phone_calls_create, description: 'This app will be able to initiate calls on your phone.'}
  ]

  def perform
    AVAILABLE_SCOPES.each do |scope_data|
      scope = Scope.where(key: scope_data[:key]).first

      scope = Scope.create(key: scope_data[:key]) unless scope.present?
      scope.update_attributes!(description: scope_data[:description])
    end
  end
end