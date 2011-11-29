class AddUserTypeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :user_type, :integer, :default => 2   
  end

  def down
    remove_column :users, :user_type 
  end
end
