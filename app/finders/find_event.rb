class FindEvent
  def self.for(token)
    user = User.find_by_token(token)
    user.events.order_by(created_at: :asc).last
  end
end
