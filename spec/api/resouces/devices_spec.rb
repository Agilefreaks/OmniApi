require 'spec_helper'

describe API::Resources::Devices do
  include_context :with_authentificated_user

  describe "POST 'api/v1/devices'" do
    let(:params) { { identifier: 'Omega prime', name: 'The truck' } }

    context 'with new device' do
      it 'creates a new device' do
        post '/api/v1/devices', params.to_json, options
        expect(JSON.parse(last_response.body)['just_created']).to eq(true)
      end
    end

    context 'with existing device' do
      before do
        user.registered_devices.push(RegisteredDevice.new :identifier => 'Omega prime' )
        user.save
      end

      it "doesn't create a new device" do
        post '/api/v1/devices', params.to_json, options

        expect(JSON.parse(last_response.body)['just_created']).to eq(false)
      end
    end

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
end
