require 'spec_helper'

describe ContactBuilder do
  let(:builder) { ContactBuilder.new }

  describe :build do
    include_context :with_authenticated_user

    let(:params) do
      {
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

    subject { builder.build(access_token.token, params) }

    it 'creates a new contact for the user associated with the token' do
      expect { subject }.to change { user.contacts.count }.by(1)
    end

    its(:contact_id) { is_expected.to eq(42) }
    its(:first_name) { is_expected.to eq('John') }
    its(:last_name) { is_expected.to eq('Doe') }
    its('phone_numbers.first.number') { is_expected.to eq('123') }
    its('phone_numbers.first.type') { is_expected.to eq('work') }
    its('phone_numbers.last.number') { is_expected.to eq('456') }
    its('phone_numbers.last.type') { is_expected.to eq('home') }
    its(:image) { is_expected.to eq('someData') }
  end
end
