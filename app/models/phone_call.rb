class PhoneCall
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String
  field :contact_name, type: String
  field :contact_id, type: Integer

  belongs_to :user
end
