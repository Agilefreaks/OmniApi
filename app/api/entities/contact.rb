module API
  module Entities
    class Contact < BaseEntity
      expose :contact_id, :first_name, :last_name, :phone_numbers, :image
    end
  end
end
