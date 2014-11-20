require_relative 'event'

class IncomingSmsEvent < Event
  field :phone_number, type: String
  field :content, type: String
  field :contact_name, type: String

  validates_presence_of :phone_number
  validates_presence_of :content
end
