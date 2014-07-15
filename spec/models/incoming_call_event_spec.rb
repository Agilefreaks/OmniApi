require 'spec_helper'

describe IncomingCallEvent do
  it { should validate_presence_of(:phone_number) }
end
