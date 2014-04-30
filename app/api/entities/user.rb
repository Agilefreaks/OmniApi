module API
  module Entities
    class User < Grape::Entity
      expose(:id) { |user, _options| user.id.to_s }
      expose :email
      expose :first_name
      expose :last_name
      expose :sign_in_count
      expose :providers, using: API::Entities::Provider
    end
  end
end
