require 'spec_helper'

describe IncomingCallNotification do
  it { should validate_presence_of(:phone_number) }
end
