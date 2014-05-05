class ClippingFactory
  def create(token, content)
    User.find_by_token(token).clippings.create(content: content, type: get_type(content))
  end

  private

  def get_type(content)
    case content
    when /^[0-9+\(\)#\.\s\/ext-]+$/
      Clipping::TYPES[:phone_number]
    when %r{https?://[\S]+}
      Clipping::TYPES[:web_site]
    when /^[a-zA-Z0-9\s,\.,\-]+,.*$/
      Clipping::TYPES[:address]
    else
      Clipping::TYPES[:unknown]
    end
  end
end
