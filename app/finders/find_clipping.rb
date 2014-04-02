module FindClipping
  def self.for(token)
    user = User.find_by_token(token)
    user.clippings.order_by(:created_at.asc).last
  end
end
