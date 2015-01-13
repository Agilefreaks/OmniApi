require_relative 'base_entity'

module API
  module Entities
    class PhoneCall < BaseEntity
      expose :number, :contact_name
    end
  end
end
