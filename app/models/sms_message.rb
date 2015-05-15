class SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :phone_number, type: String
  field :contact_name, type: String
  field :contact_id, type: Integer
  field :content, type: String
  field :phone_number_list, type: Array, default: []
  field :contact_name_list, type: Array, default: []
  field :content_list, type: Array, default: []
  field :state, type: String
  field :send_at, type: DateTime

  scope :scheduled, -> { where(state: 'scheduled') }

  belongs_to :user

  validates_inclusion_of :state, in: %w(sending sent received scheduled)
end
