require 'spec_helper'

describe Call::Update do
  describe :with do
    include_context :with_authenticated_user

    let(:phone_call) { Fabricate(:phone_call, user: user) }
    let(:params) { { access_token: access_token.token, id: phone_call.id, device_id: '42', type: type, state: state } }

    subject { Call::Update.with(params) }

    context 'when type is incoming' do
      let(:type) { 'incoming' }

      context 'and state ending' do
        let(:state) { 'ending' }

        its(:state) { is_expected.to eq 'ending' }

        it 'will call end_phone_call_requested' do
          expect_any_instance_of(NotificationService).to receive(:end_phone_call_requested).with(phone_call, '42')
          subject
        end
      end

      context 'and state ended' do
        let(:state) { 'ended' }

        it 'will call phone_call_ended' do
          expect_any_instance_of(NotificationService).to receive(:phone_call_ended).with(phone_call, '42')
          subject
        end
      end
    end

    context 'when type outgoing' do
      let(:type) { 'outgoing' }

      context 'when type started' do
        let(:state) { 'started' }

        it 'will call phone_call_started' do
          expect_any_instance_of(NotificationService).to receive(:outgoing_started).with(phone_call, '42')
          subject
        end
      end
    end
  end
end
