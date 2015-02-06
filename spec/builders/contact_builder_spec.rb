require 'spec_helper'

describe ContactBuilder do
  let(:builder) { ContactBuilder.new }

  describe :build do
    include_context :with_authenticated_user

    let(:params) do
      {
        contact_id: 'someId12',
        first_name: 'John',
        last_name: 'Doe',
        phone_numbers: %w(123 456),
        image: 'someData'
      }
    end

    subject { builder.build(access_token.token, params) }

    it 'creates a new contact for the user associated with the token' do
      expect { subject }.to change { user.contacts.count }.by(1)
    end

    its(:contact_id) { is_expected.to eq('someId12') }
    its(:first_name) { is_expected.to eq('John') }
    its(:last_name) { is_expected.to eq('Doe') }
    its(:phone_numbers) { is_expected.to eq(%w(123 456)) }
    its(:image) { is_expected.to eq('someData') }
  end
end
