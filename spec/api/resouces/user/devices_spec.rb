require 'spec_helper'

describe API::Resources::User::Devices do
  include_context :with_authenticated_user

  describe "POST 'api/v1/user/devices'" do
    let(:params) { { name: 'The truck', public_key: '123' } }

    before do
      post '/api/v1/user/devices', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
    end

    subject { JSON.parse(last_response.body) }

    its(['name']) { is_expected.to eq 'The truck' }

    its(['public_key']) { is_expected.to eq '123' }
  end

  describe "GET 'api/v1/user/devices/:id'" do
    before do
      device = Fabricate(:device, user: user, name: 'Existing device')
      get "/api/v1/user/devices/#{device._id}", '', options
    end

    subject { JSON.parse(last_response.body) }

    its(['name']) { is_expected.to eq 'Existing device' }
  end

  describe "GET 'api/v1/user/devices'" do
    subject { JSON.parse(last_response.body) }

    context 'when the user has devices' do
      before do
        Fabricate(:device, user: user, name: 'Existing device')
        Fabricate(:device, user: user, name: 'Existing device')
        get '/api/v1/user/devices', '', options
      end

      its(:size) { is_expected.to eq 2 }
    end

    context 'when the user has old registered_devices' do
      before do
        Fabricate(:registered_device, user: user, identifier: 'Existing device 1')
        Fabricate(:registered_device, user: user, identifier: 'Existing device 2')
        Fabricate(:registered_device, user: user, identifier: 'Existing device 3')
        get '/api/v1/user/devices', '', options
      end

      its(:size) { is_expected.to eq 3 }
    end
  end

  describe "DELETE 'api/v1/user/devices/:id'" do
    before do
      device = Fabricate(:device, user: user, name: 'Existing device')
      delete "/api/v1/user/devices/#{device._id}", '', options
    end

    subject { last_response }

    it { is_expected.to be_ok }
  end

  describe "PUT 'api/v1/user/devices/:id'" do
    before do
      device = Fabricate(:device, user: user, name: 'Existing device')
      put "/api/v1/user/devices/#{device._id}", { name: 'Ion' }.to_json, options
    end

    subject { JSON.parse(last_response.body) }

    its(['name']) { is_expected.to eq 'Ion' }
  end

  describe "PATCH 'api/v1/user/devices/:id'" do
    before do
      device = Fabricate(:device, user: user, name: 'Existing device')
      patch "/api/v1/user/devices/#{device._id}", { registration_id: '42', provider: :gcm }.to_json, options
    end

    subject { JSON.parse(last_response.body) }

    its(['name']) { is_expected.to eq 'Existing device' }

    its(['registration_id']) { is_expected.to eq '42' }

    its(['provider']) { is_expected.to eq 'gcm' }
  end
end
