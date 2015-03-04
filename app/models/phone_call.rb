class PhoneCall
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String
  field :contact_name, type: String
  field :contact_id, type: Integer
  field :state, type: String

  belongs_to :user

  validates_inclusion_of :state, in: %w(starting started ended ending)
end
