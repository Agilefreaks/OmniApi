class FindContactList
  def self.for(params)
    user = User.find_by_token(params[:access_token])

    user.contact_lists.find_by(identifier: params[:identifier])
  end
end
