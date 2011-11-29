class AddSaunasToSaunas < ActiveRecord::Migration
  def change
    add_column :saunas, :user_id, :integer
  end
end
