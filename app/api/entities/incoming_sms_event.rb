require_relative 'event'

module API
  module Entities
    class IncomingSmsEvent < API::Entities::Event
      expose :content
    end
  end
end
