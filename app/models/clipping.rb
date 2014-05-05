class Clipping
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = {
    phone_number: :phone_number,
    web_site: :web_site,
    address: :address,
    unknown: :unknown
  }

  field :content, type: String
  field :type, type: Symbol

  embedded_in :user
end
