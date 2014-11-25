require_relative 'event'

module API
  module Entities
    class IncomingSmsEvent < API::Entities::Event
      expose :content, :contact_name, :phone_number
    end
  end
end
