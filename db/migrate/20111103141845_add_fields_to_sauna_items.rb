class AddFieldsToSaunaItems < ActiveRecord::Migration
  def change
    add_column :sauna_items, :description, :string
    add_column :sauna_items, :sauna_type_id, :integer
    add_column :sauna_items, :has_kitchen, :boolean
    add_column :sauna_items, :has_restroom, :boolean
    add_column :sauna_items, :has_billiards, :boolean
    add_column :sauna_items, :has_audio, :boolean
    add_column :sauna_items, :has_video, :boolean
    add_column :sauna_items, :has_bar, :boolean
    add_column :sauna_items, :min_price, :integer
    add_column :sauna_items, :capacity, :integer
    add_column :sauna_items, :min_duration, :integer
  end
end
