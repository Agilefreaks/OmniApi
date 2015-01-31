require 'spec_helper'

describe CreateClipping do
  include_context :with_authenticated_user

  let(:params) { { access_token: access_token.token, content: 'some content' } }
  let(:service) { CreateClipping.new(params) }

  describe :with do
    let(:clipping_builder) { double(ClippingBuilder) }
    let(:notification_service) { double(NotificationService) }
    let(:clipping) { Clipping.new }

    # rubocop:disable AbcSize
    def setup
      service.clipping_builder = clipping_builder
      service.notification_service = notification_service

      allow(clipping_builder).to receive(:build).and_return(clipping)
    end

    context 'with device_id' do
      before do
        params.merge!(device_id: '12')
        setup
      end

      it 'will call NotificationService#notify' do
        expect(notification_service).to receive(:clipping_created).with(clipping, '12')
        service.create
      end
    end
  end
end
