require 'spec_helper'

describe Event do
  it { should be_embedded_in(:user) }

  it { should validate_presence_of :identifier }
end
