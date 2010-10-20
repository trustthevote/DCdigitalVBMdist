class ReplaceNameWithPartsInRegistrations < ActiveRecord::Migration
  def self.up
    add_column    :registrations, :first_name, :string
    add_column    :registrations, :middle_name, :string
    add_column    :registrations, :last_name, :string
    remove_index  :registrations, :column => [ :name, :zip ]
    remove_column :registrations, :name
    remove_index  :registrations, :ssn4_hash
    add_index     :registrations, :column => [ :last_name, :zip, :ssn4_hash ], :unique => true
  end

  def self.down
    remove_index  :registrations, [ :last_name, :zip, :ssn4_hash ]
    add_index     :registrations, :ssn4_hash
    add_column    :registrations, :name, :string
    add_index     :registrations, [ :name, :zip ], :unique => true
    remove_column :registrations, :last_name
    remove_column :registrations, :middle_name
    remove_column :registrations, :first_name
  end
end
