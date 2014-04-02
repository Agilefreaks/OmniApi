require 'spec_helper'

describe Call do
  let(:call) { Call.new(token, phone_number) }

  describe :with do
    let(:notification_service) { double(:notification_service) }
    let(:user) { Fabricate(:user) }
    let(:access_token) { AccessToken.build }
    let(:token) { access_token.token }
    let(:phone_number) { '898989' }

    before do
      user.access_tokens.push(access_token)
      user.save

      call.notification_service = notification_service
      allow(notification_service).to receive(:notify)
    end

    it 'will send a call notification with the correct params' do
      expect(notification_service).to receive(:notify).with(an_instance_of(PhoneNumber), '')
      call.execute
    end
  end
end