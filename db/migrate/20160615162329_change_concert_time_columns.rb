class ChangeConcertTimeColumns < ActiveRecord::Migration[5.0]
  def up
    remove_column :concerts, :time
    change_column :concerts, :date, :datetime
    rename_column :concerts, :date, :time_of_day
  end

  def down
    add_column :concerts, :time, :time
    change_column :concerts, :date, :date
    rename_column :concerts, :time_of_day, :date
  end
end
