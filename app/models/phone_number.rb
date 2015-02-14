class PhoneNumber
  include Mongoid::Document

  field :number, type: String
  field :type, type: String

  embedded_in :contact
end
