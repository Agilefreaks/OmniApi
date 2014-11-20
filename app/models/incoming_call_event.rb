require_relative 'event'

class IncomingCallEvent < Event
  field :phone_number, type: String
  field :contact_name, type: String

  validates_presence_of :phone_number
end
