require 'spec_helper'

describe NotificationService do
  let(:service) { NotificationService.new }
  let(:gcm) { double(:gcm) }
  let(:omni_sync) { double(:omni_sync) }
  let(:user) { Fabricate(:user) }
  let(:source_identifier) { 'tv' }

  before :each do
    allow(GCM).to receive(:new).and_return(gcm)
    allow(gcm).to receive(:send_notification)

    allow(OmniSync).to receive(:new).and_return(omni_sync)
  end

  describe :notify do
    context 'when model is clipping' do
      let(:clipping) { Clipping.new }

      it 'will call clipping and pass model' do
        allow(service).to receive(:clipping)
        expect(service).to receive(:clipping).with(clipping, source_identifier)
        service.notify(clipping, source_identifier)
      end
    end

    context 'when model is PhoneNumber' do
      let(:phone_number) { PhoneNumber.new }

      it 'will call phone_number and pass model' do
        allow(service).to receive(:phone_number)
        expect(service).to receive(:phone_number).with(phone_number, source_identifier)
        service.notify(phone_number, source_identifier)
      end
    end
  end

  shared_examples :notification_provider do |provider, hash|
    context 'when user has no registered devices' do
      it 'will not call send_notification' do
        expect(send(provider)).to_not receive(:send_notification)
        service.notify(model, source_identifier)
      end
    end

    context 'when user has registered devices' do
      before :each do
        user.registered_devices.create(registration_id: '42', identifier: 'tv', provider: provider)
        user.registered_devices.create(registration_id: '43', identifier: 'radio', provider: provider)
        user.registered_devices.create(registration_id: '44', identifier: 'phone', provider: provider)
      end

      it 'will call send_notification with the correct params' do
        expect(send(provider)).to receive(:send_notification).with(%w(43 44), hash).once
        service.notify(model, source_identifier)
      end
    end
  end

  describe :clipping do
    let(:model) { Clipping.new(user: user) }

    it_behaves_like :notification_provider, :gcm, data: { registration_id: 'other', provider: 'clipboard' }
    it_behaves_like :notification_provider, :omni_sync, data: { registration_id: 'other', provider: 'clipboard' }
  end

  describe :phone_number do
    let(:model) { PhoneNumber.new(user: user, content: '123') }

    it_behaves_like :notification_provider, :gcm,
                    data: { registration_id: 'other', phone_number: '123', provider: 'phone' }
    it_behaves_like :notification_provider, :omni_sync,
                    data: { registration_id: 'other', phone_number: '123', provider: 'phone' }
  end
end
