require 'spec_helper'

describe API::Resources::User::Contacts do
  include_context :with_authenticated_user

  describe "POST 'api/v1/user/contacts'" do
    let(:params) do
      {
        contact_id: 'someId12',
        first_name: 'John',
        last_name: 'Doe',
        phone_numbers: %w(123 456),
        image: 'someData'
      }
    end

    before do
      post '/api/v1/user/contacts', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
    end

    subject { JSON.parse(last_response.body) }

    its(['contact_id']) { is_expected.to eq 'someId12' }

    its(['first_name']) { is_expected.to eq 'John' }

    its(['last_name']) { is_expected.to eq 'Doe' }

    its(['phone_numbers']) { is_expected.to eq %w(123 456) }

    its(['image']) { is_expected.to eq 'someData' }
  end

  describe "GET 'api/v1/user/contacts'" do
    let(:from_time) { Time.new(2015,1,1,1,0,0) }

    let(:action) { get "/api/v1/user/contacts?from=#{from_time.iso8601}", '', options.merge('HTTP_CLIENT_VERSION' => '42') }

    subject { action }

    it 'searches for contacts for the current user' do
      expect(FindContacts).to receive(:for).with(access_token.token, from_time).and_return([])

      subject
    end

    context 'the search returns results' do
      let!(:contacts) { [Fabricate(:contact, user: user), Fabricate(:contact, user: user)] }

      before { allow(FindContacts).to receive(:for).and_return(contacts) }

      describe 'the response' do
        before { action }

        let(:json_response) { JSON.parse(last_response.body, symbolize_names: true) }

        subject { json_response }

        its(:length) { is_expected.to eq(2) }

        it { is_expected.to include(API::Entities::Contact.represent(contacts[0]).as_json ) }

        it { is_expected.to include(API::Entities::Contact.represent(contacts[1]).as_json ) }
      end
    end
  end
end
