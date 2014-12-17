require 'spec_helper'

describe API::Resources::Sync do
  include_context :with_authenticated_user

  describe "POST '/api/v1/sync'" do
    let(:params) { { identifier: 'sound system', what: :contacts } }

    subject { post '/api/v1/sync', params.to_json, options }

    it 'will call notify on notification service with correct params' do
      expect_any_instance_of(NotificationService).to receive(:notify).with(kind_of(ContactList), 'sound system')
      subject
    end
  end
end
