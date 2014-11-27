require 'spec_helper'

describe :EndCall do
  describe :with do
    include_context :with_authenticated_user

    let(:end_call) { EndCall.new(access_token.token) }
    let(:notification_service) { double(:notification_service) }

    before do
      end_call.notification_service = notification_service
    end

    it 'will send a end_call notification with the correct params' do
      expect(notification_service).to receive(:end_call).with(an_instance_of(PhoneNumber), '')
      end_call.execute
    end
  end
end
