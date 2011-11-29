class CreateSaunaTypes < ActiveRecord::Migration
  def change
    create_table :sauna_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
