require_relative 'timestamp_base_entity'

module API
  module Entities
    class User < TimestampBaseEntity
      expose :email
      expose :first_name
      expose :last_name
      expose :image_url
      expose :via_omnipaste
      expose :plan
      expose :access_token do |user, _options|
        user.access_tokens.last.token
      end
      expose :contacts_updated_at
    end
  end
end
