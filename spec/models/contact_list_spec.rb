require 'spec_helper'

describe ContactList do
  it { is_expected.to be_embedded_in(:user) }

  it { is_expected.to validate_presence_of(:identifier) }
end
