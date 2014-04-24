module API
  module Entities
    class AuthorizationCode < Grape::Entity
      expose :code
    end
  end
end
