class UpdateRegistrationFields < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :city
    remove_column :registrations, :state
    add_column    :registrations, :ssn4_hash, :string
    add_index     :registrations, :ssn4_hash
  end

  def self.down
    remove_index  :registrations, :ssn4_hash
    remove_column :registrations, :ssn4_hash
    add_column    :registrations, :state, :string
    add_column    :registrations, :city, :string
  end
end
