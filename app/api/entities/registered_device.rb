require_relative 'base_entity'

module API
  module Entities
    class RegisteredDevice < BaseEntity
      expose :identifier, :name, :registration_id, :public_key
    end
  end
end
