require 'spec_helper'

describe :Sms do
  describe :with do
    include_context :with_authentificated_user

    let(:notification_service) { double(:notification_service) }
    let(:phone_number) { '898989' }
    let(:content) { 'I am to see you!' }
    let(:sms) { Sms.new(access_token.token, phone_number, content) }

    before do
      sms.notification_service = notification_service
    end

    it 'will send a call notification with the correct params' do
      expect(notification_service).to receive(:sms).with(an_instance_of(SmsMessage), '')
      sms.execute
    end
  end
end
