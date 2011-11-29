class CreateSaunaComments < ActiveRecord::Migration
  def change
    create_table :sauna_comments do |t|
      t.string :user_name
      t.string :description
      t.integer :sauna_id

      t.timestamps
    end
  end
end
