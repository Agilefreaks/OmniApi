require_relative 'base_entity'

module API
  module Entities
    class Device < BaseEntity
      expose :id, :name, :provider, :registration_id, :public_key
    end
  end
end
