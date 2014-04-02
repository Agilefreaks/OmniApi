require 'spec_helper'

describe API::Resources::Devices do
  include Rack::Test::Methods

  def app
    OmniApi::App.instance
  end

  let(:access_token) { '42' }

  describe "POST 'api/v1/devices'" do
    include_context :with_authentificated_user

    let(:options) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => 'bearer 42' } }
    let(:params) { { :'identifier' => 'Omega prime', :'name' => 'The truck' } }

    it 'will call Register.device with the correct params' do
      expect(Register).to receive(:device).with(access_token: access_token, identifier: 'Omega prime', name: 'The truck')
      post '/api/v1/devices', params.to_json, options
    end
  end

  describe "DELETE 'api/v1/devices/:identifier'" do
    include_context :with_authentificated_user

    let(:options) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => 'bearer 42' } }

    it 'will call Unregister device with the correct params' do
      expect(Unregister).to receive(:device).with(access_token: access_token, identifier: 'sony tv')
      delete '/api/v1/devices/sony%20tv', nil, options
    end
  end
  #
  # describe "PUT 'api/v1/devices/activate'" do
  #   let(:options) { { :'CONTENT_TYPE' => 'application/json', :'ACCEPT' => 'application/json', :'CHANNEL' => current_user.email } }
  #   let(:params) { { :'registration_id' => '42', :'identifier' => 'sony tv' } }
  #
  #   it 'will call ActivateDevice with the correct params' do
  #     expect(ActivateDevice).to receive(:with).with('channel' => current_user.email, 'identifier' => 'sony tv', 'registration_id' => '42')
  #     put '/api/v1/devices/activate', params.to_json, options
  #   end
  # end
  #
  # describe "PUT 'api/v1/devices/deactivate'" do
  #   let(:options) { { :'CONTENT_TYPE' => 'application/json', :'ACCEPT' => 'application/json', :'CHANNEL' => current_user.email } }
  #   let(:params) { { :'identifier' => 'sony tv' } }
  #
  #   it 'will call Unregister device with the correct params' do
  #     expect(DeactivateDevice).to receive(:with).with('channel' => current_user.email, 'identifier' => 'sony tv')
  #     put '/api/v1/devices/deactivate', params.to_json, options
  #   end
  # end
end