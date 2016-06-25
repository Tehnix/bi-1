class RenameLikeUserIdToStrangerId < ActiveRecord::Migration[5.0]
  def up
    rename_column :likes, :user_id, :stranger_id
  end

  def down
    rename_column :likes, :stranger_id, :user_id
  end
end
