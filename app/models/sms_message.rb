class SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone_number, type: String
  field :contact_name, type: String
  field :content, type: String
  field :phone_number_list, type: Array, default: []
  field :contact_name_list, type: Array, default: []
  field :content_list, type: Array, default: []

  belongs_to :user
end
