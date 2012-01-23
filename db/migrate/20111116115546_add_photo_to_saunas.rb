class AddEmailToSaunas < ActiveRecord::Migration
  def change
    add_column :saunas, :email, :string
  end
end
