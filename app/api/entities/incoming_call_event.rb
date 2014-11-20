require_relative 'event'

module API
  module Entities
    class IncomingCallEvent < API::Entities::Event
      expose :phone_number, :contact_name
    end
  end
end
