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

describe PagesController do

  it "should display the front page" do
    get :front
    response.should render_template(:front)
  end

  context "when not voting" do
    it "should redirect to front page" do
      before_voting_started
      get :overview
      response.should redirect_to(front_url)
    end
  end
  
  context "when going to overview page" do
    it "should just show whatever it is" do
      get :overview
      response.should render_template(:overview)
    end
  end
  
  context "when checking in" do
    it "should display form" do
      get :check_in
      response.should render_template(:check_in)
    end
    
    it "should return to the check in form if record wasn't found" do
      post :check_in, :registration => { :name => "unknown" }
      response.should render_template(:check_in)
      assigns(:registration).should be_nil
    end
    
    it "should move on to the confirm page when record was found" do
      r = Factory(:registration)
      post :check_in, :registration => { :name => r.name, :zip => r.zip }
      response.should redirect_to(confirm_url)
    end
  end

  context "when requesting attestation PDF" do
    it "should redirect to check-in if haven't checked in yet" do
      get :attestation, :format => 'pdf'
      response.should redirect_to(check_in_url)
    end
    
    it "should render the PDF if checked in" do
      stub_registration
      get :attestation, :format => 'pdf'
      response.should render_template(:attestation)
    end
  end
  
  context "when confirming" do
    before { stub_registration }
    
    it "should render the page" do
      get :confirm
      response.should render_template(:confirm)
    end
  end

  context "when completing" do
    it "should render the page" do
      stub_registration
      Registration.any_instance.expects(:register_check_in!)
      get :complete
      response.should render_template(:complete)
    end
  end
  
  context "when viewing thanks" do
    before { stub_registration }

    it "should render the page" do
      get :thanks
      response.should render_template(:thanks)
    end
    
    it "should register the completion" do
      Registration.any_instance.expects(:register_flow_completion!)
      get :thanks
    end
  end

  context "when viewing supplementary pages" do
    context "and currently before the voting started" do
      before { before_voting_started }
      
      %w{ about contact }.each do |page|
        it "should render #{page} page" do
          get page.to_sym
          response.should render_template(page)
        end
      end
    end
  end

  def stub_registration
    @r = Factory(:registration)
    session[:rid] = @r.id
  end
end
