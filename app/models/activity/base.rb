class Activity::Base < ActiveRecord::Base

  set_table_name 'activity_log'

  belongs_to :registration

end
