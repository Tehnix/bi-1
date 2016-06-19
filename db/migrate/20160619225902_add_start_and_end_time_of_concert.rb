class AddStartAndEndTimeOfConcert < ActiveRecord::Migration[5.0]
  def up
    rename_column :concerts, :time_of_day, :start_time
    add_column :concerts, :end_time, :datetime
  end

  def down
    rename_column :concerts, :start_time, :time_of_day
    remove_column :concerts, :end_time
  end
end
