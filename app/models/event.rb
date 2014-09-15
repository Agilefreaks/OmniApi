class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identifier

  belongs_to :user

  validates_presence_of :identifier
end
