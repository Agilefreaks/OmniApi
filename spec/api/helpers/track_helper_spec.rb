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
      let(:declared_params) { { registration_id: registration_id } }

      context 'when the registration id is set' do
        let(:registration_id) { '42' }

        it 'will call TrackingService with activation event' do
          expected_params = ['hang@on.com', TrackingService::ACTIVATION_EVENT, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end

      context 'when the registration is not set' do
        let(:registration_id) { nil }

        it 'will call TrackingService with deactivation event' do
          expected_params = ['hang@on.com', TrackingService::DEACTIVATION_EVENT, hash_including(email: 'hang@on.com')]
          expect(TrackingService).to receive(:track).with(*expected_params)
          subject
        end
      end
    end

    context 'when the route is post' do
      let(:route) { Grape::Route.new(method: 'POST') }
      let(:declared_params) { { } }

      it 'will call TrackingService with registration event' do
        expected_params = ['hang@on.com', TrackingService::REGISTRATION_EVENT, hash_including(email: 'hang@on.com')]
        expect(TrackingService).to receive(:track).with(*expected_params)
        subject
      end
    end
  end
end