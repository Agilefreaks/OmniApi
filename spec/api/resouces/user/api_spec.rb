require 'spec_helper'

describe API::Resources::User::Api do
  include_context :with_authenticated_client

  describe :contacts do
    include_context :with_authenticated_user

    describe "POST '/user/contacts'" do
      let(:params) { { identifier: 'nexus', destination_identifier: 'ubuntu', contacts: 'an encrypted list' } }

      subject { post '/api/v1/user/contacts', params.to_json, options }

      it 'will call CreateContactList' do
        with_params = params.merge(access_token: access_token.token)
        expect(CreateContactList).to receive(:with).with(with_params)

        subject
      end
    end

    describe "GET '/user/contacts'" do
      let(:params) { { identifier: 'ubuntu' } }

      subject { get '/api/v1/user/contacts', params, options }

      before :each do
        allow(FindContactList).to receive(:for).and_return(contact_list)
      end

      context 'when there is a contact list available' do
        let(:contact_list) { Fabricate(:contact_list, contacts: 'gibberish', identifier: 'ubuntu', user: user) }

        it 'will call GetContactList with the correct params' do
          expect(FindContactList).to receive(:for).with(access_token: access_token.token, identifier: 'ubuntu')
          subject
        end

        it 'will return the content in contacts field' do
          subject
          expect(JSON.parse(last_response.body)['contacts']).to eq('gibberish')
        end
      end
    end
  end

  describe :devices do
    include_context :with_authenticated_user

    describe "POST 'api/v1/user/devices'" do
      let(:params) { { name: 'The truck' } }

      before do
        post '/api/v1/user/devices', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
      end

      subject { JSON.parse(last_response.body) }

      its(['name']) { is_expected.to eq 'The truck' }
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
end
