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

    context 'when user has devices' do
      before do
        Fabricate(:device, user: user, name: 'nexus 4', provider: provider, registration_id: 'registration1')
        Fabricate(:device, user: user, name: 'nexus 5', provider: provider, registration_id: 'registration2')
      end

      it 'will call send_notification with the devices' do
        expect(send(provider)).to receive(:send_notification).with(%w(registration1 registration2), hash)
        service.notify(model, source_identifier)
      end
    end
  end

  shared_examples :interaction_notification_provider do |interaction, provider, hash|
    context 'when user has no registered devices' do
      it 'will not call send_notification' do
        expect(send(provider)).to_not receive(:send_notification)
        service.send(interaction, model, source_identifier)
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
        service.send(interaction, model, source_identifier)
      end
    end
  end

  describe :clipping do
    let(:model) { Clipping.new(user: user, id: BSON::ObjectId.from_string('5494468a63616c6cfb000000')) }

    it_behaves_like :notification_provider, :gcm,
                    data: { registration_id: 'other', provider: 'clipboard', id: '5494468a63616c6cfb000000' }
    it_behaves_like :notification_provider, :omni_sync,
                    data: { registration_id: 'other', provider: 'clipboard', id: '5494468a63616c6cfb000000' }
  end

  describe :incoming_call_event do
    let(:model) { IncomingCallEvent.new(id: '42', user: user, identifier: '123', phone_number: '123') }

    it_behaves_like :notification_provider, :gcm, data: { registration_id: 'other', provider: 'notification' }
    it_behaves_like :notification_provider, :omni_sync, data: { registration_id: 'other', provider: 'notification' }
  end

  describe :incoming_sms_event do
    let(:model) { IncomingSmsEvent.new(id: '42', user: user, identifier: '123', phone_number: '123', content: 'con') }

    it_behaves_like :notification_provider, :gcm, data: { registration_id: 'other', provider: 'notification' }
    it_behaves_like :notification_provider, :omni_sync, data: { registration_id: 'other', provider: 'notification' }
  end

  describe :contact_list do
    let(:model) { Fabricate(:contact_list, user: user, identifier: '42', contacts: 'contacts') }

    it_behaves_like :notification_provider, :gcm,
                    data: { registration_id: 'other', provider: 'contacts', identifier: '42' }
    it_behaves_like :notification_provider, :omni_sync,
                    data: { registration_id: 'other', provider: 'contacts', identifier: '42' }
  end

  describe :call do
    let(:model) { PhoneCall.new(user: user, number: '123') }

    it_behaves_like :interaction_notification_provider, :call, :gcm,
                    data: { registration_id: 'other', phone_number: '123', phone_action: 'call', provider: 'phone' }
    it_behaves_like :interaction_notification_provider, :call, :omni_sync,
                    data: { registration_id: 'other', phone_number: '123', phone_action: 'call', provider: 'phone' }
  end

  describe :end_call do
    let(:model) { PhoneCall.new(user: user) }

    it_behaves_like :interaction_notification_provider, :end_call, :gcm,
                    data: { registration_id: 'other', phone_action: 'end_call', provider: 'phone' }
    it_behaves_like :interaction_notification_provider, :end_call, :omni_sync,
                    data: { registration_id: 'other', phone_action: 'end_call', provider: 'phone' }
  end

  describe :sms do
    let(:model) { SmsMessage.new(user: user, phone_number: '911', content: 'I have fire in my heart!') }

    it_behaves_like :interaction_notification_provider, :sms, :gcm,
                    data:
                      {
                        registration_id: 'other',
                        phone_action: 'sms',
                        provider: 'phone',
                        phone_number: '911',
                        sms_content: 'I have fire in my heart!'
                      }
    it_behaves_like :interaction_notification_provider, :sms, :omni_sync,
                    data:
                      {
                        registration_id: 'other',
                        phone_action: 'sms',
                        provider: 'phone',
                        phone_number: '911',
                        sms_content: 'I have fire in my heart!'
                      }
  end
end
