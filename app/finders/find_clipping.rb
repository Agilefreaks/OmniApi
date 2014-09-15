module FindClipping
  def self.for(token)
    user = User.find_by_token(token)

    if user.new_clippings.empty?
      user.new_clippings.push(user.clippings.map do |c|
                                NewClipping.new(content: c.content, type: c.type, created_at: c.created_at,
                                                updated_at: c.updated_at)
                              end
      )
      user.save
    end

    user.new_clippings.order_by(:created_at.asc).last
  end
end
