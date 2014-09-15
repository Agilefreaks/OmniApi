require 'spec_helper'

describe API::Resources::Users do
  include_context :with_authenticated_client

  describe 'GET /users' do
    let(:params) { { email: 'some@email.com' } }

    subject { get '/api/v1/users', params, options }

    context 'with no user' do
      it 'will do something' do
        subject
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'POST /users' do
    let(:params_for_ion) { { email: 'ion@user.com', first_name: 'Ion' } }
    let(:params_for_gheo) { { email: 'gheo@user.com', first_name: 'Gheo' } }

    subject {
      post '/api/v1/users', params_for_ion.to_json, options
      post '/api/v1/users', params_for_gheo.to_json, options
    }

    it 'will create user' do
      expect { subject }.to change(User, :count).by(2)
    end
  end
end
