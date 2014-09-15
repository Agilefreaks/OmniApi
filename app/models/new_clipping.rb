class NewClipping
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: 'clippings'

  TYPES = {
    phone_number: :phone_number,
    url: :url,
    address: :address,
    unknown: :unknown
  }

  field :content, type: String
  field :type, type: Symbol

  belongs_to :user
end
