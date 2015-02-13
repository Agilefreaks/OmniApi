require_relative 'base_entity'

module API
  module Entities
    class PhoneNumber < BaseEntity
      expose :number, :type
    end
  end
end
