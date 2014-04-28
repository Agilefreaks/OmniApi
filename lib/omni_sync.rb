class OmniSync
  include HTTParty

  base_uri Configuration.omni_sync_url

  attr_accessor :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def send_notification(registration_id, options = {})
    post_body = { registration_id: registration_id }.merge(options)

    params = {
      :body => post_body.to_json,
      :headers => {
        'Authorization' => "#{@api_key}",
        'Content-Type' => 'application/json',
      }
    }

    self.class.post('', params)
  end
end