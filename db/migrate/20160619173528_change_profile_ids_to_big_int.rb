class ChangeProfileIdsToBigInt < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :id, :integer, limit: 8
  end

  def down
    change_column :users, :id, :integer
  end
end
