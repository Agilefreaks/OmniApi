class FindContacts
  def self.for(token, timestamp = nil)
    user = User.find_by_token(token)

    contacts = user.contacts
    contacts = contacts.where(:updated_at.gte => timestamp) if timestamp.present?
    contacts
  end
end
