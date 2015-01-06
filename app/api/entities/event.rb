module API
  module Entities
    class Event < BaseEntity
      expose :identifier
      expose :_type, as: :type
    end
  end
end
