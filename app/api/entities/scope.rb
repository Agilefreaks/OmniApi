require_relative 'base_entity'

module API
  module Entities
    class Scope < BaseEntity
      expose :key, :description
    end
  end
end
