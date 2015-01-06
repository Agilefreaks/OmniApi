class PhoneCall
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String

  belongs_to :user
end
