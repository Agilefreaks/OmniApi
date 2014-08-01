class SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone_number, type: String
  field :content, type: String

  belongs_to :user
end
