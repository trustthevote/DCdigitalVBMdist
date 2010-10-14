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

class Stats
  
  def run
    total      = Registration.count
    inactive   = Registration.inactive.count
    unfinished = Registration.unfinished.count
    finished   = Registration.finished.count

    [ [ "Total number of voters", total ],
      [ "Inactive", "#{inactive} (#{percent(inactive, total)})" ],
      [ "Used the system but not finished", "#{unfinished} (#{percent(unfinished, total)})" ],
      [ "Used the system and finished", "#{finished} (#{percent(finished, total)})" ] ].each do |f|
      puts "%-50s: %s" % f
    end
    
    log
  end
  
  private
  
  def percent(n, t)
    "%6.2f%%" % (100.0 * n / t)
  end
  
  def log
    puts
    puts "Activity log:"
    puts
    
    Activity::Base.all(:order => "created_at", :include => :registration).each do |r|
      puts r.description
    end
  end
  
end