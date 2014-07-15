class EventFactory
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def create(type, params = {})
    user = User.find_by_token(@token)

    event_klass = type.to_s.split('_').map(&:capitalize).join.concat('Event').constantize
    event = event_klass.new(params)
    user.events.push(event)
    user.save

    event
  end
end
