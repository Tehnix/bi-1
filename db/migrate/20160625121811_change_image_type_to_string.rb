class ChangeImageTypeToString < ActiveRecord::Migration[5.0]
  def up
    change_column :images, :image_type, :string
  end

  def down
    change_column :images, :image_type, :integer
  end
end
