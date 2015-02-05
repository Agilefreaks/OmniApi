module API
  module Entities
    class Contact < Grape::Entity
      expose :contact_id
      expose :first_name
      expose :last_name
      expose :phone_numbers
      expose :image
    end
  end
end
