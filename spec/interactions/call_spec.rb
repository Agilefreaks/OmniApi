require 'spec_helper'

describe Call do
  let(:call) { Call.new(access_token.token, phone_number) }

  describe :with do
    include_context :with_authenticated_user

    let(:notification_service) { double(:notification_service) }
    let(:phone_number) { '898989' }

    before do
      call.notification_service = notification_service
    end

    it 'will send a call notification with the correct params' do
      expect(notification_service).to receive(:call).with(an_instance_of(PhoneCall), '')
      call.execute
    end
  end
end
