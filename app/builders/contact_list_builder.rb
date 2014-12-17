class ContactListBuilder
  def build(token, identifier, contacts)
    user = User.find_by_token(token)
    contact_list = user.contact_lists.find_or_create_by(identifier: identifier)
    contact_list.update_attribute(:contacts, contacts)

    contact_list
  end
end
