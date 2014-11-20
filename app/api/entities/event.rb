module API
  module Entities
    class Event < Grape::Entity
      expose :id, :identifier
      expose :_type, as: :type
    end
  end
end
