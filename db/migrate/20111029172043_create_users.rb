class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
	  t.integer :balance_amount
	  t.string :wmr_purse
      t.timestamps
    end
  end
end
