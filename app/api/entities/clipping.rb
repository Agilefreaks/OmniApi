require_relative 'timestamp_base_entity'

module API
  module Entities
    class Clipping < TimestampBaseEntity
      expose :content, :type
    end
  end
end
