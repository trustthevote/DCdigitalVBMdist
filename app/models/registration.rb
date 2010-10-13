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

require 'digest/sha1'

class Registration < ActiveRecord::Base

  belongs_to  :precinct_split

  validates_presence_of :pin_hash
  validates_presence_of :precinct_split_id

  named_scope :inactive,   :conditions => { :checked_in_at => nil }
  named_scope :checked_in, :conditions => "checked_in_at IS NOT NULL"
  named_scope :unfinished, :conditions => [ "checked_in_at IS NOT NULL AND last_completed_at IS NULL" ]
  
  def self.match(r)
    first(:conditions => {
      :name     => r[:name],
      :pin_hash => Registration.hash_pin(r[:pin]),
      :zip      => r[:zip],
      :voter_id => r[:voter_id] })
  end

  def pin=(v)
    self.pin_hash = Registration.hash_pin(v)
  end

  # Returns the blank ballot PDF
  def blank_ballot
    precinct_split.try(:ballot_style).try(:pdf)
  end

  def self.hash_pin(pin)
    return nil if pin.blank?
    Digest::SHA1.hexdigest(pin.to_s.gsub(/[^0-9A-Z]/i, '').upcase)
  end

  def register_flow_completion!
  end
  
  def register_check_in!
  end
  
end
