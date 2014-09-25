class OmniSync
  include HTTParty

  base_uri Configuration.omni_sync_url

  attr_accessor :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def send_notification(registration_ids, options = {})
    post_body = { registration_ids: '' }.merge(options)

    registration_ids.each do |rid|
      params = {
        body: post_body.to_json,
        headers: {
          'Authorization' => "#{@api_key}",
          'Content-Type' => 'application/json',
          'Ws-Synctoken' => rid
        }
      }

      self.class.post('/api/v1/notify', params)
    end
  end
end
