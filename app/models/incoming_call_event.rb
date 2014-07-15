require_relative 'event'

class IncomingCallEvent < Event
  field :phone_number

  validates_presence_of :phone_number
end
