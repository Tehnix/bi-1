class CreateFriendships < ActiveRecord::Migration[5.0]
  def change
    create_table :friendships do |t|
      t.belongs_to :friend
      t.belongs_to :user
    end
  end
end
