require 'spec_helper'

describe ContactBuilder do
  let(:builder) { ContactBuilder.new }

  describe :build do
    include_context :with_authenticated_user

    let(:params) {
      {
        contact_id: 'someId12',
        first_name: 'John',
        last_name: 'Doe',
        phone_numbers: %w(123 456),
        image: 'someData'
      }
    }

    subject { builder.build(access_token.token, params) }

    it 'creates a new contact for the user associated with the token' do
      expect { User.contacts.count }.to change.by(1)
    end
  end
end