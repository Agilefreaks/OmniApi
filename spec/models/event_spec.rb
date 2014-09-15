require 'spec_helper'

describe Event do
  it { should belong_to(:user) }

  it { should validate_presence_of :identifier }
end
