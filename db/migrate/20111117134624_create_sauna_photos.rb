class CreateSaunaPhotos < ActiveRecord::Migration
  def change
    create_table :sauna_photos do |t|
      t.string :description
      t.integer :sauna_id
      t.string :photo_file_name
      t.integer :photo_file_size

      t.timestamps
    end
  end
end
