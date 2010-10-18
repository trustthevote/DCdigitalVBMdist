# Version: OSDV Public License 1.2
# The contents of this file are subject to the OSDV Public License
# Version 1.2 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.osdv.org/license/
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
# See the License for the specific language governing rights and limitations
# under the License.
# 
# The Original Code is:
# 	TTV UOCAVA Ballot Portal.
# The Initial Developer of the Original Code is:
# 	Open Source Digital Voting Foundation.
# Portions created by Open Source Digital Voting Foundation are Copyright (C) 2010.
# All Rights Reserved.
# 
# Contributors: Paul Stenbjorn, Aleksey Gureiev, Robin Bahr,
# Thomas Gaskin, Sean Durham, John Sebes.

require 'spec_helper'

describe Registration do

  it { should have_many :activity_records }

  let(:registration) { Factory(:registration) }

  it "should return the empty ballot PDF" do
    b = Factory(:ballot_style)
    r = Factory(:registration, :precinct_split_id => b.precinct_split_id)
    
    r.blank_ballot.url.should == b.pdf.url
  end

  describe "when matches" do
    it "should find the record that matches info" do
      r = Factory(:registration, :ssn4 => "1234")
      Registration.match(:name => r.name, :zip => r.zip, :ssn4 => "1234").should eql r # Strangely '==' doesn't work here
    end
  
    it "should return nil if nothing was found" do
      Registration.match(:name => "Unknown", :zip => "24001", :ssn4 => '').should be_nil
    end
  end

  context "logging activities" do
    it "should register the completion" do
      Timecop.freeze do
        registration.register_flow_completion!
        registration.activity_records.map(&:type).should == [ "Activity::Completion" ]
        registration.completed_at.should == Time.now
      end
    end
    
    it "should register the check-in" do
      Timecop.freeze do
        registration.register_check_in!
        registration.activity_records.map(&:type).should == [ "Activity::CheckIn" ]
        registration.checked_in_at.should == Time.now
      end
    end
  end
  
  context "status named scopes" do
    before do
      @unchecked  = Factory(:registration)
      @unfinished = Factory(:registration, :checked_in_at => 2.minutes.ago)
      @finished   = Factory(:registration, :completed_at => 1.minute.ago)
    end
    
    it "should return correct records for .finished" do
      Registration.finished.should        == [ @finished ]
    end
    
    it "should return correct records for .checked_in" do
      Registration.checked_in.should      include @unfinished
      Registration.checked_in.should      include @finished
      Registration.checked_in.should_not  include @unchecked
    end
    
    it "should return correct records for .unfinished" do
      Registration.unfinished.should      == [ @unfinished ]
    end
    
    it "should return correct records for .inactive" do
      Registration.inactive.should        == [ @unchecked ]
    end
  end
  
  context "when setting ssn4" do
    before  { registration.ssn4 = "1234" }
    specify { registration.ssn4_hash.should_not be_nil }
  end
end
