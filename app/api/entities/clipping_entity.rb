module API
  module Entities
    class ClippingEntity < Grape::Entity
      expose :id, :content, :type, :created_at
    end
  end
end
