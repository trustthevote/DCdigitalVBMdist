class AddFlagsToRegistrations < ActiveRecord::Migration
  def self.up
    add_column    :registrations, :completed_at,  :datetime
    add_column    :registrations, :checked_in_at, :datetime
    add_index     :registrations, :completed_at
    add_index     :registrations, :checked_in_at
  end

  def self.down
    remove_index  :registrations, :completed_at
    remove_index  :registrations, :checked_in_at
    remove_column :registrations, :completed_at
    remove_column :registrations, :checked_in_at
  end
end
