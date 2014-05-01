require 'spec_helper'

describe NotificationFactory do
  include_context :with_authentificated_user

  let(:factory) { NotificationFactory.new(access_token.token) }

  describe :create do
    subject { factory.create(:incoming_call, identifier: '42', phone_number: '0745857479') }

    it 'will create a incoming_call notification' do
      subject
      user.reload
      notification = user.notifications.last
      expect(notification).to be_a_kind_of(IncomingCallNotification)
    end

    its(:identifier) { should == '42' }

    its(:phone_number) { should == '0745857479' }
  end
end