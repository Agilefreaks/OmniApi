class FindContacts
  def self.for(token, params = {})
    user = User.find_by_token(token)

    contacts = user.contacts
    contacts = contacts.where(:updated_at.gte => params[:from]) if params.key?(:from)
    contacts = contacts.find_by(contact_id: params[:contact_id]) if params.key?(:contact_id)
    contacts
  end
end
