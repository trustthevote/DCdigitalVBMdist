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

class PagesController < ApplicationController

  before_filter :block_wrong_time,  :except => [ :front, :about, :contact ]
  before_filter :load_registration, :only   => [ :confirm, :attestation, :complete, :return, :thanks ]

  def overview
  end

  def check_in
    forget_registration
    perform_check if request.post?
  end

  def confirm
  end

  def attestation
    render_pdf "attestation"
  end
  
  def complete
    @registration.register_check_in!
  end
  
  def return
  end
  
  def thanks
    @registration.register_flow_completion!
  end
  
  private
  
  def perform_check
    r = params[:registration]
    return if r.nil?
    
    # Find the registration and remember it
    @registration = Registration.match(r)
    if @registration
      session[:rid] = @registration.id
      redirect_to confirm_url
    end
  end

  def forget_registration
    session[:rid] = nil
  end
  
  def load_registration
    unless session[:rid]
      redirect_to check_in_url
      return false
    else
      @registration = Registration.find(session[:rid])
    end
  end

  def block_wrong_time
    redirect_to front_url unless during_voting?
  end
end