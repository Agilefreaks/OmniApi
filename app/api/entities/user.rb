module API
  module Entities
    class User < Grape::Entity
      expose :email
      expose :first_name
      expose :last_name
      expose :image_url
      expose :via_omnipaste
      expose :access_token do |user, _options|
        user.access_tokens.last.token
      end
      expose :contacts_updated_at
    end
  end
end
