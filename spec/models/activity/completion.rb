require 'spec_helper'

describe Activity::Completion do
  it { should belong_to(:registration) }
end