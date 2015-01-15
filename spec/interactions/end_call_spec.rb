require 'spec_helper'

describe :EndCall do
  describe :with do
    include_context :with_authenticated_user

    let(:phone_call) { Fabricate(:phone_call, user: user) }
    let(:notification_service) { double(:notification_service) }
    let(:end_call) { EndCall.new(access_token.token, phone_call.id, '42') }

    before do
      end_call.notification_service = notification_service
    end

    subject { end_call.execute }

    it 'will send a end_call notification with the correct params' do
      expect(notification_service).to receive(:notify).with(phone_call, '42')
      expect(notification_service).to receive(:end_call).with(phone_call, '42')
      subject
    end
  end
end
