require 'spec_helper'

describe API::Resources::Devices do
  include Rack::Test::Methods

  def app
    OmniApi::App.instance
  end

  let(:options) {
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => "bearer #{access_token.token}" }
  }

  describe "POST 'api/v1/devices'" do
    include_context :with_authentificated_user

    let(:params) { { :'identifier' => 'Omega prime', :'name' => 'The truck' } }

    it 'will call Register.device with the correct params' do
      expect(Register).to receive(:device).
                            with(access_token: access_token.token, identifier: 'Omega prime', name: 'The truck')
      post '/api/v1/devices', params.to_json, options
    end
  end

  describe "DELETE 'api/v1/devices/:identifier'" do
    include_context :with_authentificated_user

    it 'will call Unregister device with the correct params' do
      expect(Unregister).to receive(:device).with(access_token: access_token.token, identifier: 'sony tv')
      delete '/api/v1/devices/sony%20tv', nil, options
    end
  end

  describe "PUT 'api/v1/devices/activate'" do
    include_context :with_authentificated_user

    let(:params) { { :'registration_id' => '42', :'identifier' => 'sony tv' } }

    it 'will call ActivateDevice with the correct params' do
      expect(ActivateDevice).to receive(:with).
                                  with(access_token: access_token.token,
                                       identifier: 'sony tv',
                                       registration_id: '42',
                                       provider: nil)
      put '/api/v1/devices/activate', params.to_json, options
    end
  end

  describe "PUT 'api/v1/devices/deactivate'" do
    include_context :with_authentificated_user

    let(:params) { { :'identifier' => 'sony tv' } }

    it 'will call Unregister device with the correct params' do
      expect(DeactivateDevice).to receive(:with).with(access_token: access_token.token, identifier: 'sony tv')
      put '/api/v1/devices/deactivate', params.to_json, options
    end
  end
end
