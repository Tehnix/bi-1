class RemoveChatConnectionIdFromChats < ActiveRecord::Migration[5.0]
  def up
    remove_column :chats, :chat_connection_id
  end

  def down
    add_column :chats, :chat_connection_id, :integer
  end
end
