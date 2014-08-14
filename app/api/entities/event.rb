module API
  module Entities
    class Event < Grape::Entity
      expose :id, :identifier, :phone_number
      expose :_type, as: :type
    end
  end
end
