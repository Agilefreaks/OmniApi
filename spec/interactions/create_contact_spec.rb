require 'spec_helper'

describe CreateContact do
  include_context :with_authenticated_user

  let(:contact_params) do
    {
      device_id: 'device id',
      contact_id: 42,
      first_name: 'John',
      last_name: 'Doe',
      phone_numbers: %w(123 456),
      image: 'someData'
    }
  end
  let(:params) { { access_token: access_token.token }.merge(contact_params) }
  let(:service) { CreateContact.new(params) }

  describe :create do
    let(:contact_builder) { double(ContactBuilder) }
    let(:contact) { Fabricate(:contact, user: user) }

    before do
      allow(contact_builder).to receive(:build).and_return(contact)
      service.contact_builder = contact_builder
    end

    subject { service.create }

    it 'calls build with the access token and the contact params' do
      expect(contact_builder).to receive(:build).with(access_token.token, contact_params.except(:device_id))

      subject
    end

    it 'updates the contacts_updated_at field for the current user with the current time' do
      new_time = Time.local(2015, 1, 1, 1, 0, 0)
      Timecop.freeze(new_time)

      expect { subject }.to change { user.reload.contacts_updated_at }.to(new_time)

      Timecop.return
    end

    it { is_expected.to be(contact) }

    it 'will call NotificationService#contact_created' do
      expect_any_instance_of(NotificationService).to receive(:contact_created).with(kind_of(Contact), 'device id')
      subject
    end
  end
end
