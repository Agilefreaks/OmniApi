require 'spec_helper'

describe NotificationService do
  let(:service) { NotificationService.new }
  let(:gcm) { double(:gcm) }
  let(:omni_sync) { double(:omni_sync) }
  let(:user) { Fabricate(:user) }

  before :each do
    allow(GCM).to receive(:new).and_return(gcm)
    allow(gcm).to receive(:send_notification)

    allow(OmniSync).to receive(:new).and_return(omni_sync)
    allow(omni_sync).to receive(:send_notification)
  end

  shared_examples :interaction_notification_provider do |interaction, hash|
    [:gcm, :omni_sync].each do |provider|
      let(:source_device_id) { BSON::ObjectId.from_string('5494468a64616c6cfb000000') }

      context 'when user has no devices' do
        it 'will not call send_notification' do
          expect(send(provider)).to_not receive(:send_notification)
          service.send(interaction, model, source_device_id)
        end
      end

      context 'when user has devices' do
        before :each do
          Fabricate(:device, user: user, id: source_device_id, registration_id: '42', provider: provider)
          Fabricate(:device, user: user, registration_id: '43', provider: provider)
          Fabricate(:device, user: user, registration_id: '44', provider: provider)
        end

        it 'will call send_notification with the correct params' do
          expect(send(provider)).to receive(:send_notification).with(%w(43 44), hash).once
          service.send(interaction, model, source_device_id)
        end
      end
    end
  end

  describe :clipping_created do
    let(:model) { Fabricate(:clipping, id: BSON::ObjectId.from_string('5494468a63616c6cfb000000'), user: user) }

    it_behaves_like :interaction_notification_provider,
                    :clipping_created,
                    data: {
                      type: 'clipping_created',
                      payload: {
                        id: '5494468a63616c6cfb000000'
                      }
                    }
  end

  # rubocop:disable Metrics/LineLength
  %w(end_phone_call_requested phone_call_received start_phone_call_requested phone_call_ended outgoing_started).each do |event|
    context event do
      let(:model) { Fabricate(:phone_call, id: BSON::ObjectId.from_string('5424468a63616c6cfb000000'), user: user) }

      it_behaves_like :interaction_notification_provider,
                      event,
                      data: {
                        type: event,
                        payload: {
                          id: '5424468a63616c6cfb000000'
                        }
                      }
    end
  end

  %w(sms_message_received send_sms_message_requested sms_message_sent).each do |event|
    context event do
      let(:model) { Fabricate(:sms_message, id: BSON::ObjectId.from_string('5424468a63616c6cfb000000'), user: user) }

      it_behaves_like :interaction_notification_provider,
                      event,
                      data: {
                        type: event,
                        payload: {
                          id: '5424468a63616c6cfb000000'
                        }
                      }
    end
  end

  %w(contact_created contact_updated).each do |event|
    context event do
      let(:model) { Fabricate(:contact, id: BSON::ObjectId.from_string('5424468a63616c6cfb000001'), user: user) }

      it_behaves_like :interaction_notification_provider,
                      event,
                      data: {
                        type: event,
                        payload: {
                          id: '5424468a63616c6cfb000001'
                        }
                      }
    end
  end

  %w(contacts_updated).each do |event|
    let(:model) { OpenStruct.new(user: user) }

    context event do
      it_behaves_like :interaction_notification_provider,
                      event,
                      data: {
                        type: event
                      }
    end
  end
end
