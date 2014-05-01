class IncomingCallNotification < Notification
  field :phone_number

  validates_presence_of :phone_number
end