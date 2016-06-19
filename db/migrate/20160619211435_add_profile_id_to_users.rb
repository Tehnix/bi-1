class AddProfileIdToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :profile_id, :integer, limit: 8
  end

  def down
    remove_column :users, :profile_id
  end
end
