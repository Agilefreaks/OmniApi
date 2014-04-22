module API
  module Entities
    class User < Grape::Entity
      expose(:id) { |user, options| user.id.to_s }
      expose :first_name
      expose :last_name
      expose :providers, using: API::Entities::Provider
    end
  end
end
