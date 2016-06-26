class RemoveStrangerAndInterestIdenfitiersFromLikes < ActiveRecord::Migration[5.0]
  def up
    remove_column :likes, :stranger_id
    remove_column :likes, :interest_id
  end

  def down
    add_column :likes, :stranger_id, :integer
    add_column :likes, :interest_id, :integer
  end
end
