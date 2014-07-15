require 'spec_helper'

describe EventFactory do
  include_context :with_authentificated_user

  let(:factory) { EventFactory.new(access_token.token) }

  describe :create do
    subject { factory.create(:incoming_call, identifier: '42', phone_number: '0745857479') }

    it 'will create a incoming_call event' do
      subject
      user.reload
      event = user.events.last
      expect(event).to be_a_kind_of(IncomingCallEvent)
    end

    its(:identifier) { should == '42' }

    its(:phone_number) { should == '0745857479' }
  end
end
