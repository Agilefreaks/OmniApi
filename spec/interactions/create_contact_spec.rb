require 'spec_helper'

describe CreateContact do
  include_context :with_authenticated_user

  let(:contact_params) {
    {
      contact_id: 'someId12',
      first_name: 'John',
      last_name: 'Doe',
      phone_numbers: %w(123 456),
      image: 'someData'
    }
  }
  let(:params) { { access_token: access_token.token }.merge(contact_params) }
  let(:service) { CreateContact.new(params) }

  describe :create do
    let(:contact_builder) { double(ContactBuilder) }

    before { service.contact_builder = contact_builder }

    subject { service.create }

    it 'calls build with the access token and the contact params' do
      expect(contact_builder).to receive(:build).with(access_token.token, contact_params)

      subject
    end

    context 'the builder returns a contact' do
      let(:contact) { Contact.new }

      before { allow(contact_builder).to receive(:build).and_return(contact) }

      it { is_expected.to be(contact)}
    end
  end
end