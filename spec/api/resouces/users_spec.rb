require 'spec_helper'

describe API::Resources::Users do
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
    let(:params) { { email: 'a@user.com', first_name: 'Ion', last_name: 'din Deal' } }

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

    context 'when the access_token is expiring'
  end
end
