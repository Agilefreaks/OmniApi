require 'spec_helper'

describe FindNotification do
  describe :for do
    include_context :with_authentificated_user

    let!(:notification1) { user.notifications.create(identifier: 'Phone') }
    let!(:notification2) { user.notifications.create(identifier: 'TV') }

    subject { FindNotification.for(access_token.token, notification1.id) }

    it { should == notification1 }
  end
end