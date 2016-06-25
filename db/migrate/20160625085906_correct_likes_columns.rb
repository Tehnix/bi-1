class CorrectLikesColumns < ActiveRecord::Migration[5.0]
  def change
    remove_reference :likes, :stranger
    add_reference :likes, :interest
  end
end
