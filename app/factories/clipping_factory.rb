class ClippingFactory
  def create(token, content)
    User.find_by_token(token).clippings.create(content: content, type: get_type(content))
  end

  private

  def get_type(content)
    case content
    when /^[0-9+\(\)#\.\s\/ext-]+$/
      Clipping::TYPES[:phone_number]
    when /^https?:\/\/[\S]+$/
      Clipping::TYPES[:url]
    when /^[\p{L}0-9\s,\.,\-]+,[\S,\s,\d]+$/
      Clipping::TYPES[:address]
    else
      Clipping::TYPES[:unknown]
    end
  end
end
