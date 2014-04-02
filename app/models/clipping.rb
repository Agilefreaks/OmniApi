class Clipping
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = {
    phone_number: :phone_number,
    web_site: :web_site,
    unknown: :unknown
  }

  field :content, type: String
  field :type, type: Symbol

  embedded_in :user

  index created_at: -1
end
