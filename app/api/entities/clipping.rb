module API
  module Entities
    class Clipping < Grape::Entity
      expose :id, :content, :type, :created_at
    end
  end
end
