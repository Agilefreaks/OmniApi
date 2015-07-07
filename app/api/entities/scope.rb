require_relative 'base_entity'

module API
  module Entities
    class Scope < Grape::Entity
      expose :key, :description
    end
  end
end
