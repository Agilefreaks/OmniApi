require 'spec_helper'

describe Scope do
  it { should have_field(:key).of_type(Symbol) }
  it { should have_field(:description).of_type(String) }
end
