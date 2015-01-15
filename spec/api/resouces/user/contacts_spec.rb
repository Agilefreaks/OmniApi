require 'spec_helper'

describe API::Resources::User::Contacts do
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
