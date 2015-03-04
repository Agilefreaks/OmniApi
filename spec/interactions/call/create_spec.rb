require 'spec_helper'

describe Call::Create do
  let(:call) { Call::Create.new(Call::Create::CallParams.new(params)) }

  describe :with do
    include_context :with_authenticated_user

    let(:params) do
      { access_token: access_token.token,
        number: '898989',
        contact_name: 'Ion',
        contact_id: 43,
        device_id: '42',
        state: state,
        type: type }
    end
    let(:notification_service) { double(:notification_service) }

    before do
      call.notification_service = notification_service
    end

    context 'when incoming and starting' do
      let(:type) { 'incoming' }
      let(:state) { 'starting' }

      it 'will send a incoming call notification with the correct params' do
        expect(notification_service).to receive(:phone_call_received).with(an_instance_of(PhoneCall), '42')
        call.execute
      end
    end

    context 'when outgoing and started' do
      let(:type) { 'outgoing' }
      let(:state) { 'starting' }

      it 'will send a call notification with the correct params' do
        expect(notification_service).to receive(:start_phone_call_requested).with(an_instance_of(PhoneCall), '42')
        call.execute
      end
    end
  end
end
