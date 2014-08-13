module API
module Entities
  class Event < Grape::Entity
    expose :id, :identifier, :phone_number
    expose :content, if: lambda { |obj, _options| obj.is_a? IncomingSmsEvent }
    expose :_type, as: :type
  end
end
end
