require 'spec_helper'

describe API::Resources::Devices do
  include_context :with_authentificated_user

  describe "POST 'api/v1/devices'" do
    let(:params) { { identifier: 'Omega prime', name: 'The truck' } }

    it 'will call Register.device with the correct params' do
      expect(Register).to receive(:device)
                          .with(access_token: access_token.token, identifier: 'Omega prime', name: 'The truck')
      post '/api/v1/devices', params.to_json, options
    end
  end

  describe "DELETE 'api/v1/devices/:identifier'" do
    it 'will call Unregister device with the correct params' do
      expect(Unregister).to receive(:device)
                            .with(access_token: access_token.token, identifier: 'sony tv')
      delete '/api/v1/devices/sony%20tv', nil, options
    end
  end

  describe "PUT 'api/v1/devices/activate'" do
    let(:params) { { registration_id: '42', identifier: 'sony tv' } }

    it 'will call ActivateDevice with the correct params' do
      expect(ActivateDevice).to receive(:with)
                                .with(access_token: access_token.token,
                                      identifier: 'sony tv',
                                      registration_id: '42',
                                      provider: nil)
      put '/api/v1/devices/activate', params.to_json, options
    end
  end

  describe "PUT 'api/v1/devices/deactivate'" do
    let(:params) { { identifier: 'sony tv' } }

    it 'will call Unregister device with the correct params' do
      expect(DeactivateDevice).to receive(:with)
                                  .with(access_token: access_token.token, identifier: 'sony tv')
      put '/api/v1/devices/deactivate', params.to_json, options
    end
  end

  describe "GET 'api/v1/devices/'" do
    let(:devices) { [Fabricate(:registered_device, user: user, identifier: 'sony tv', name: 'sony tv')] }

    before do
      user.registered_devices = devices
    end

    it 'will return all registered devices for the user' do
      get '/api/v1/devices', '', options

      expect(JSON.parse(last_response.body)).to have_exactly(1).items
    end
  end
end
