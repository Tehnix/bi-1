class AddFriendshipToUser < ActiveRecord::Migration[5.0]
  def up
    add_reference :users, :friendship
  end

  def down
    remove_reference :users, :friendship
  end
end
