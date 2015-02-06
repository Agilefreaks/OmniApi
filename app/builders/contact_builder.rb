class ContactBuilder
  def build(token, params)
    User.find_by_token(token).contacts.create(params)
  end
end