require_relative 'timestamp_base_entity'

module API
  module Entities
    class Device < TimestampBaseEntity
      expose :name, :provider, :registration_id, :public_key
    end
  end
end
