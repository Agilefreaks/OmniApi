require 'spec_helper'

describe Call::Create do
  describe :with do
    include_context :with_authenticated_user

    let(:params) do
      { access_token: access_token.token,
        number: '898989',
        contact_name: 'Ion',
        contact_id: 43,
        device_id: '42',
        state: state,
        type: type
      }
    end

    subject { Call::Create.with(params) }

    context 'when incoming and starting' do
      let(:type) { 'incoming' }
      let(:state) { 'starting' }

      it 'will send a incoming call notification with the correct params' do
        expect_any_instance_of(NotificationService)
          .to receive(:phone_call_received)
          .with(an_instance_of(PhoneCall), '42')
        subject
      end

      its(:state) { is_expected.to eq 'starting' }
    end

    context 'when outgoing and started' do
      let(:type) { 'outgoing' }
      let(:state) { 'starting' }

      it 'will send a call notification with the correct params' do
        expect_any_instance_of(NotificationService)
          .to receive(:start_phone_call_requested)
          .with(an_instance_of(PhoneCall), '42')
        subject
      end
    end
  end
end
