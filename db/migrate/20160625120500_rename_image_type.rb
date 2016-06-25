class RenameImageType < ActiveRecord::Migration[5.0]
  def change
    rename_column :images, :type, :image_type
  end
end
