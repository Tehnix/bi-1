class DeleteUnnecessaryUserFields < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :friendship_id
    remove_column :users, :like_id
  end

  def down
    add_column :users, :friendship_id, :integer
    add_column :users, :like_id, :integer
  end
end
