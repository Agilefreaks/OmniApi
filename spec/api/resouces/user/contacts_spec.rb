require 'spec_helper'

describe API::Resources::User::Contacts do
  include_context :with_authenticated_user

  describe "POST 'api/v1/user/contacts'" do
    let(:params) do
      {
        device_id: 'device id',
        contact_id: 42,
        first_name: 'John',
        last_name: 'Doe',
        phone_numbers: [
          {
            number: '123',
            type: 'work'
          },
          {
            number: '456',
            type: 'home'
          }
        ],
        image: 'someData'
      }
    end

    subject do
      # noinspection RubyStringKeysInHashInspection
      post '/api/v1/user/contacts', params.to_json, options.merge('HTTP_NO_NOTIFICATION' => true)
      JSON.parse(last_response.body)
    end

    its(['contact_id']) { is_expected.to eq 42 }

    its(['first_name']) { is_expected.to eq 'John' }

    its(['last_name']) { is_expected.to eq 'Doe' }

    its(['image']) { is_expected.to eq 'someData' }

    it 'will create phone number' do
      phone_numbers = subject['phone_numbers']

      expect(phone_numbers.size).to eq 2
      expect(phone_numbers.first['number']).to eq '123'
      expect(phone_numbers.first['type']).to eq 'work'
      expect(phone_numbers.last['number']).to eq '456'
      expect(phone_numbers.last['type']).to eq 'home'
    end

    context 'when contact with duplicate contact_id' do
      it 'will return a bad request' do
        2.times { post '/api/v1/user/contacts', params.to_json, options }
        expect(last_response).to be_bad_request
      end
    end
  end

  describe "GET 'api/v1/user/contacts'" do
    subject { action }

    context 'from_time' do
      let(:from_time) { Time.new(2015, 1, 1, 1, 0, 0) }

      let(:action) { get "/api/v1/user/contacts?from=#{from_time.iso8601}", '', options }

      it 'call FindContacts with from' do
        expect(FindContacts).to receive(:for).with(access_token.token, from: from_time)
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

          it { is_expected.to include(API::Entities::Contact.represent(contacts[0]).as_json) }

          it { is_expected.to include(API::Entities::Contact.represent(contacts[1]).as_json) }
        end
      end
    end

    context 'contact_id' do
      let(:contact_id) { 42 }

      let(:action) { get "/api/v1/user/contacts?contact_id=#{contact_id}", '', options }

      it 'calls FindContacts with contact id' do
        expect(FindContacts).to receive(:for).with(access_token.token, contact_id: contact_id)
        subject
      end
    end

    context 'no params' do
      let(:action) { get '/api/v1/user/contacts', '', options }

      it 'call FindContacts with nil' do
        expect(FindContacts).to receive(:for).with(access_token.token, {})
        subject
      end
    end
  end

  describe "GET 'api/v1/user/contacts/:id'" do
    let(:id) { '5424468a63616c6cfb000001' }

    subject { get "/api/v1/user/contacts/#{id}", '', options }

    it 'calls FindContacts with id' do
      expect(FindContacts).to receive(:for).with(access_token.token, id: id)
      subject
    end
  end
end
