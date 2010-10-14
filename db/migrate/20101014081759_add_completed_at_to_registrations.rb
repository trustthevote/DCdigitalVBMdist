class AddCompletedAtToRegistrations < ActiveRecord::Migration
  def self.up
    add_column    :registrations, :completed_at, :datetime
    add_index     :registrations, :completed_at
  end

  def self.down
    remove_index  :registrations, :completed_at
    remove_column :registrations, :completed_at
  end
end
