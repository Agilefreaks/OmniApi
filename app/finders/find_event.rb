class FindEvent
  def self.for(token)
    user = User.find_by_token(token)
    user.events.last
  end
end
