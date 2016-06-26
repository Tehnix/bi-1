class ChangeChatsTable < ActiveRecord::Migration[5.0]
  def up
    remove_column :chats, :type
    remove_column :chats, :user_id
  end

  def down
    add_column :chats, :type, :string
    add_column :chats, :user_id, :integer
  end
end
