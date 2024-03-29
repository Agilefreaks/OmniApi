class Clipping
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = {
    phone_number: :phone_number,
    url: :url,
    address: :address,
    unknown: :unknown
  }

  field :content, type: String
  field :type, type: Symbol

  belongs_to :user, index: true
end
