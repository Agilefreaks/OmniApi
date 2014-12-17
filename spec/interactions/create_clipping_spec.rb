require 'spec_helper'

describe CreateClipping do
  include_context :with_authenticated_user

  let(:service) { CreateClipping.new(access_token: access_token.token, content: 'some content', identifier: '42') }

  describe :with do
    let(:clipping_builder) { double(ClippingBuilder) }
    let(:notification_service) { double(NotificationService) }
    let(:clipping) { Clipping.new }

    before :each do
      service.clipping_builder = clipping_builder
      service.notification_service = notification_service

      allow(clipping_builder).to receive(:build).and_return(clipping)
      allow(notification_service).to receive(:notify)
    end

    it 'will call ClippingFactory#create' do
      expect(clipping_builder).to receive(:build).with(access_token.token, 'some content')
      service.create
    end

    it 'will call NotificationService#notify' do
      expect(notification_service).to receive(:notify).with(clipping, '42')
      service.create
    end

    it 'will return a clipping' do
      expect(service.create).to eq clipping
    end
  end
end
