require 'spec_helper'

describe Activity::Base do
  it { should belong_to(:registration) }
end