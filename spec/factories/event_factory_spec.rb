require 'spec_helper'

describe EventFactory do
  include_context :with_authentificated_user

  let(:factory) { EventFactory.new(access_token.token) }

  describe :create do
    subject { factory.create(type, params) }

    context 'for incoming call' do
      let(:type) { :incoming_call }
      let(:params) { { identifier: '42', phone_number: '0745857479' } }

      it 'will create a incoming_call event' do
        subject
        user.reload
        event = user.events.last
        expect(event).to be_a_kind_of(IncomingCallEvent)
      end

      its(:identifier) { should == '42' }

      its(:phone_number) { should == '0745857479' }
    end

    context 'for incoming sms' do
      let(:type) { :incoming_sms }
      let(:params) { { identifier: '42', phone_number: '0745857479', content: 'Ta na na na!' } }

      it 'will create a incoming_sms event' do
        subject
        user.reload
        event = user.events.last
        expect(event).to be_kind_of(IncomingSmsEvent)
      end

      it 'will save the event' do
        expect { subject }.to change(IncomingSmsEvent, :count).by(1)
      end

      its(:identifier) { should == '42' }

      its(:phone_number) { should == '0745857479' }

      its(:content) { should == 'Ta na na na!' }
    end
  end
end
