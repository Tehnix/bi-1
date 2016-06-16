class CreateConcerts < ActiveRecord::Migration[5.0]
  def change
    create_table :concerts do |t|
      t.string :artist
      t.time :time
      t.date :date
      t.string :venue

      t.timestamps
    end
  end
end
