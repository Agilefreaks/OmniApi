require 'spec_helper'

describe Call do
  let(:call) { Call.new(Call::CallParams.new(params)) }

  describe :with do
    include_context :with_authenticated_user

    let(:params) do
      { access_token: access_token.token,
        number: '898989',
        contact_name: 'Ion',
        device_id: '42',
        state: state }
    end
    let(:notification_service) { double(:notification_service) }

    before do
      call.notification_service = notification_service
    end

    context 'when state is incoming' do
      let(:state) { :incoming }

      it 'will send a incoming call notification with the correct params' do
        expect(notification_service).to receive(:incoming_call).with(an_instance_of(PhoneCall), '42')
        call.execute
      end
    end

    context 'when state is initiate' do
      let(:state) { :initiate }

      it 'will send a call notification with the correct params' do
        expect(notification_service).to receive(:call).with(an_instance_of(PhoneCall), '42')
        call.execute
      end
    end
  end
end
