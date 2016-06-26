class AddOwnerToLikes < ActiveRecord::Migration[5.0]
  def up
    add_reference :likes, :owner
    add_reference :likes, :interest
  end

  def down
    remove_reference :likes, :owner
    remove_reference :likes, :interest
  end
end
