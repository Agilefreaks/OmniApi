require_relative 'timestamp_base_entity'
module API
  module Entities
    class AuthorizationCode < TimestampBaseEntity
      expose :code
    end
  end
end
