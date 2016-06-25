class DeleteUnnecessaryUserFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :friendship_id
    remove_column :users, :like_id
  end
end
