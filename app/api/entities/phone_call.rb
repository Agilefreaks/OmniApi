require_relative 'timestamp_base_entity'

module API
  module Entities
    class PhoneCall < TimestampBaseEntity
      expose :number, :contact_name
    end
  end
end
