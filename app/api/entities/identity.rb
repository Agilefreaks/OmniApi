require_relative 'timestamp_base_entity'

module API
  module Entities
    class Identity < TimestampBaseEntity
      expose :provider, :scope, :expires, :expires_at, :token, :refresh_token
    end
  end
end
