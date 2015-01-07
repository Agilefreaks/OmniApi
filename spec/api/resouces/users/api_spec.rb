require 'spec_helper'

describe API::Resources::Users::Api do
  include_context :with_authenticated_client

  describe 'GET /users' do
    subject { get '/api/v1/users', params, options }

    context 'with email' do
      let(:params) { { email: 'some@email.com' } }

      context 'with no user' do
        it 'will return status OK' do
          subject
          expect(last_response.status).to eq 200
        end
      end
    end

    context 'with no params' do
      include_context :with_authenticated_user

      let(:params) { {} }

      it 'will return status ok' do
        get '/api/v1/users', nil, options
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'POST /users' do
    let(:params_for_ion) { { email: 'ion@user.com', first_name: 'Ion' } }
    let(:params_for_gheo) { { email: 'gheo@user.com', first_name: 'Gheo' } }

    subject do
      post '/api/v1/users', params_for_ion.to_json, options
      post '/api/v1/users', params_for_gheo.to_json, options
    end

    it 'will create user' do
      expect { subject }.to change(User, :count).by(2)
    end
  end

  describe 'PUT /users' do
    let!(:user) { Fabricate(:user, email: 'a@user.com') }
    let(:params) { { email: 'a@user.com', first_name: 'Ion', last_name: 'din Deal', image_url: 'http://some.image' } }

    subject do
      put '/api/v1/users', params.to_json, options
      user.reload
    end

    before do
      access_token = GenerateOauthToken.build_access_token_for(user, client.id)
      access_token.update_attribute(:expires_at, Time.now.utc)
    end

    its(:first_name) { is_expected.to eq 'Ion' }

    its(:last_name) { is_expected.to eq 'din Deal' }

    its(:image_url) { is_expected.to eq 'http://some.image' }

    context 'when the access_token is expiring'
  end

  describe :contacts do
    include_context :with_authenticated_user

    describe "POST '/users/contacts'" do
      let(:params) { { identifier: 'nexus', destination_identifier: 'ubuntu', contacts: 'an encrypted list' } }

      subject { post '/api/v1/users/contacts', params.to_json, options }

      it 'will call CreateContactList' do
        with_params = params.merge(access_token: access_token.token)
        expect(CreateContactList).to receive(:with).with(with_params)

        subject
      end
    end

    describe "GET '/users/contacts'" do
      let(:params) { { identifier: 'ubuntu' } }

      subject { get '/api/v1/users/contacts', params, options }

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

    describe "POST 'api/v1/users/devices'" do
      let(:params) { { name: 'The truck' } }

      before do
        post '/api/v1/users/devices', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
      end

      subject { JSON.parse(last_response.body) }

      its(['name']) { is_expected.to eq 'The truck' }
    end

    describe "GET 'api/v1/users/devices/:id'" do
      before do
        device = Fabricate(:device, user: user, name: 'Existing device')
        get "/api/v1/users/devices/#{device._id}", '', options
      end

      subject { JSON.parse(last_response.body) }

      its(['name']) { is_expected.to eq 'Existing device' }
    end

    describe "GET 'api/v1/users/devices'" do
      subject { JSON.parse(last_response.body) }

      context 'when the user has devices' do
        before do
          Fabricate(:device, user: user, name: 'Existing device')
          Fabricate(:device, user: user, name: 'Existing device')
          get '/api/v1/users/devices', '', options
        end

        its(:size) { is_expected.to eq 2 }
      end

      context 'when the user has old registered_devices' do
        before do
          Fabricate(:registered_device, user: user, identifier: 'Existing device 1')
          Fabricate(:registered_device, user: user, identifier: 'Existing device 2')
          Fabricate(:registered_device, user: user, identifier: 'Existing device 3')
          get '/api/v1/users/devices', '', options
        end

        its(:size) { is_expected.to eq 3 }
      end
    end

    describe "DELETE 'api/v1/users/devices/:id'" do
      before do
        device = Fabricate(:device, user: user, name: 'Existing device')
        delete "/api/v1/users/devices/#{device._id}", '', options
      end

      subject { last_response }

      it { is_expected.to be_ok }
    end

    describe "PUT 'api/v1/users/devices/:id'" do
      before do
        device = Fabricate(:device, user: user, name: 'Existing device')
        put "/api/v1/users/devices/#{device._id}", { name: 'Ion' }.to_json, options
      end

      subject { JSON.parse(last_response.body) }

      its(['name']) { is_expected.to eq 'Ion' }
    end

    describe "PATCH 'api/v1/users/devices/:id'" do
      before do
        device = Fabricate(:device, user: user, name: 'Existing device')
        patch "/api/v1/users/devices/#{device._id}", { registration_id: '42', provider: :gcm }.to_json, options
      end

      subject { JSON.parse(last_response.body) }

      its(['name']) { is_expected.to eq 'Existing device' }

      its(['registration_id']) { is_expected.to eq '42' }

      its(['provider']) { is_expected.to eq 'gcm' }
    end
  end
end
