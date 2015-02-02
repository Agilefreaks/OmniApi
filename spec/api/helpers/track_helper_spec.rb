require 'spec_helper'

describe TrackHelper do
  class TrackHelperTest
    include TrackHelper
  end

  let(:track_helper) { TrackHelperTest.new }
  let(:user) { Fabricate(:user, email: 'hang@on.com') }

  before do
    track_helper.instance_variable_set(:@current_user, user)
    allow(track_helper).to receive(:params).and_return({})
    allow(track_helper).to receive(:routes).and_return([route])
  end

  describe :track_devices do
    subject { track_helper.track_devices(declared_params) }

    context 'when the route method is patch' do
      let(:route) { Grape::Route.new(method: 'PATCH') }
      let(:declared_params) { { id: '42', registration_id: registration_id, provider: 'gcm' } }

      context 'when the registration id is set' do
        let(:registration_id) { '42' }

        it 'will call TrackingService with activation event' do
          expected_params = ['hang@on.com', TrackingService::ACTIVATION, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end

      context 'when the registration is not set' do
        let(:registration_id) { nil }

        it 'will call TrackingService with deactivation event' do
          event = TrackingService::DEACTIVATION
          expected_params = ['hang@on.com', event, hash_including(device_id: '42', provider: 'gcm')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end
    end

    context 'when the route is post' do
      let(:route) { Grape::Route.new(method: 'POST') }
      let(:declared_params) { {} }

      it 'will call TrackingService with registration event' do
        expected_params = ['hang@on.com', TrackingService::REGISTRATION, hash_including(email: 'hang@on.com')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end
  end

  describe :track_phone_calls do
    subject { track_helper.track_phone_calls(declared_params) }

    context 'when route is post' do
      let(:route) { Grape::Route.new(method: 'POST') }

      context 'when incoming starting' do
        let(:declared_params) { { type: 'incoming', state: 'starting' } }

        it 'will call TrackingService with incoming call' do
          expected_params = ['hang@on.com', TrackingService::INCOMING_CALL, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end

      context 'when outgoing starting' do
        let(:declared_params) { { type: 'outgoing', state: 'starting' } }

        it 'will call TrackingService with outgoing call' do
          expected_params = ['hang@on.com', TrackingService::OUTGOING_CALL, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end
    end

    context 'when route is get' do
      let(:route) { Grape::Route.new(method: 'GET') }
      let(:declared_params) { { device_id: '42' } }

      it 'will call TrackingService with get call' do
        expected_params = ['hang@on.com', TrackingService::GET_CALL, hash_including(device_id: '42')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end

    context 'when route is patch' do
      let(:route) { Grape::Route.new(method: 'PATCH') }
      let(:declared_params) { {} }

      it 'will call TrackingService with end incoming call' do
        expected_params = ['hang@on.com', TrackingService::END_INCOMING_CALL, hash_including(email: 'hang@on.com')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end
  end

  describe :track_sms_messages do
    subject { track_helper.track_sms_messages(declared_params) }

    context 'when route is post' do
      let(:route) { Grape::Route.new(method: 'POST') }

      context 'when incoming received' do
        let(:declared_params) { { type: 'incoming', state: 'received', device_id: '42' } }

        it 'will call TrackingService with received sms' do
          expected_params = ['hang@on.com', TrackingService::RECEIVED_SMS, hash_including(device_id: '42')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end

      context 'when outgoing sending' do
        let(:declared_params) { { type: 'outgoing', state: 'sending' } }

        it 'will call TrackingService with outgoing sms' do
          expected_params = ['hang@on.com', TrackingService::OUTGOING_SMS, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end
    end

    context 'when route is get' do
      let(:route) { Grape::Route.new(method: 'GET') }
      let(:declared_params) { {} }

      it 'will call TrackingService with get sms' do
        expected_params = ['hang@on.com', TrackingService::GET_SMS, hash_including(email: 'hang@on.com')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end
  end

  describe :track_clipping do
    subject { track_helper.track_clipping(declared_params) }

    context 'when route is post' do
      let(:route) { Grape::Route.new(method: 'POST') }
      let(:declared_params) { { device_id: '42' } }

      it 'will call TrackingService with clipping' do
        expected_params = ['hang@on.com', TrackingService::CLIPPING, hash_including(device_id: '42')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end

    context 'when route is get' do
      let(:route) { Grape::Route.new(method: 'GET') }
      let(:declared_params) { { device_id: '42' } }

      it 'will call TrackingService with clipping' do
        expected_params = ['hang@on.com', TrackingService::GET_CLIPPING, hash_including(device_id: '42')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end
  end
end
