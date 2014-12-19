require 'spec_helper'

describe API::Resources::Devices do
  include_context :with_authenticated_user

  describe "POST 'api/v1/devices'" do
    subject { post '/api/v1/devices', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42') }

    let(:params) { { identifier: 'Omega prime', name: 'The truck' } }

    context 'when identifier is not nil' do
      it 'will call Register.device with the correct params' do
        expected_params = {
          access_token: access_token.token,
          identifier: 'Omega prime',
          name: 'The truck',
          client_version: '42'
        }
        expect(Register).to receive(:device).with(expected_params).and_return(RegisteredDevice.new)
        subject
      end
    end

    context 'when device is not valid' do
      it 'will return error code' do
        expect(Register).to receive(:device).and_return(RegisteredDevice.new)
        expect(subject.status).to eq 400
      end
    end
  end

  describe "DELETE 'api/v1/devices'" do
    it 'will call Unregister device with the correct params' do
      expect(Unregister).to receive(:device).with(access_token: access_token.token, identifier: 'sony tv')
      delete '/api/v1/devices', { identifier: 'sony tv' }.to_json, options
    end
  end

  describe "PUT 'api/v1/devices/activate'" do
    let(:params) { { registration_id: '42', identifier: 'sony tv' } }

    it 'will call ActivateDevice with the correct params' do
      expected_params = { access_token: access_token.token,
                          identifier: 'sony tv',
                          client_version: '42',
                          registration_id: '42' }
      expect(ActivateDevice).to receive(:with).with(expected_params)
      put '/api/v1/devices/activate', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
    end
  end

  describe "PUT 'api/v1/devices/deactivate'" do
    let(:params) { { identifier: 'sony tv' } }

    it 'will call Unregister device with the correct params' do
      expect(DeactivateDevice).to receive(:with).with(access_token: access_token.token, identifier: 'sony tv')
      put '/api/v1/devices/deactivate', params.to_json, options
    end
  end

  describe "PUT 'api/v1/devices'" do
    let(:required_params) { { identifier: 'sony tv' } }

    subject { put '/api/v1/devices', params.to_json, options }

    before do
      user.registered_devices.create(identifier: 'sony tv', name: 'the name of the tv')
    end

    context 'with public_key and name' do
      let(:params) { required_params.merge(name: 'some name', public_key: '42') }

      it 'will update the name and public_key' do
        subject
        user.reload
        device = user.registered_devices.first
        expect(device.name).to eq 'some name'
        expect(device.public_key).to eq '42'
      end
    end

    context 'with only the public_key' do
      let(:params) { required_params.merge(public_key: '42') }

      it 'will update the name and public_key' do
        subject
        user.reload
        device = user.registered_devices.first
        expect(device.name).to eq 'the name of the tv'
        expect(device.public_key).to eq '42'
      end
    end
  end

  describe "GET 'api/v1/devices'" do
    let(:devices) do
      [
        Fabricate(:registered_device, user: user, identifier: 'sony tv', name: 'sony tv'),
        Fabricate(:registered_device, user: user, identifier: 'HTC One', name: 'My phone')
      ]
    end

    subject { get '/api/v1/devices', params, options }

    before do
      user.registered_devices = devices
    end

    context 'with no identifier' do
      let(:params) { '' }

      it 'will return all registered devices for the user' do
        subject

        expect(JSON.parse(last_response.body).size).to eq(2)
      end
    end

    context 'with a identifier' do
      context 'with an existing identifier' do
        let(:params) { { identifier: 'HTC One' } }

        it 'will return the device' do
          subject
          expect(JSON.parse(last_response.body)['name']).to eq 'My phone'
        end
      end

      context 'with an invalid identifier' do
        let(:params) { { identifier: 'HTC Two' } }

        it 'will return 404' do
          subject
          expect(last_response).to be_not_found
        end
      end
    end
  end

  describe "POST 'api/v1/devices/call'" do
    let(:params) { { phone_number: '898989' } }

    it 'will call Call.device with the correct params' do
      expect(Call).to receive(:with).with(access_token: access_token.token, phone_number: '898989')
      post '/api/v1/devices/call', params.to_json, options
    end
  end

  describe "POST 'api/v1/devices/end_call'" do
    it 'will call EndCall.with' do
      expect(EndCall).to receive(:with).with(access_token: access_token.token)
      post '/api/v1/devices/end_call', nil, options
    end
  end

  describe "POST 'api/v1/devices/sms'" do
    let(:params) { { phone_number: '898989', content: 'I am hot!' } }

    it 'will call SendSmsMessage with the correct params' do
      params[:access_token] = access_token.token
      expect(SendSmsMessage).to receive(:with).with(params)
      post '/api/v1/devices/sms', params.to_json, options
    end
  end
end
