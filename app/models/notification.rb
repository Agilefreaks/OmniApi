class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identifier

  embedded_in :user

  validates_presence_of :identifier
end
