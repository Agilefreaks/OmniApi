module API
  module Entities
    class AuthorizationCode < Grape::Entity
      expose(:id) { |authorization_code, _options| authorization_code.id.to_s }
      expose :code
    end
  end
end
