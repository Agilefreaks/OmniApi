module API
  module Entities
    class Notification < Grape::Entity
      expose :id, :identifier, :phone_number
    end
  end
end
