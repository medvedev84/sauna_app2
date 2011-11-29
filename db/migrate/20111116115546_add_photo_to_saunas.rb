class AddPhotoToSaunas < ActiveRecord::Migration
  def change
    add_column :saunas, :photo_file_name, :string
  end
end
