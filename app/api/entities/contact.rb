require_relative 'timestamp_base_entity'
require_relative 'phone_number'

module API
  module Entities
    class Contact < TimestampBaseEntity
      expose :contact_id, :first_name, :last_name, :image
      expose :phone_numbers, using: API::Entities::PhoneNumber
    end
  end
end
