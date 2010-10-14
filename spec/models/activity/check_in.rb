require 'spec_helper'

describe Activity::CheckIn do
  it { should belong_to(:registration) }
end