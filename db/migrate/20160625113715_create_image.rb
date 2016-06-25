class CreateImage < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :url
      t.integer :type
      t.integer :width
      t.integer :height
      t.belongs_to :concert
    end
  end
end
