class DeleteChatUsersTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :chats_users
  end

  def down
    create_table :chats_users do |t|
      t.belongs_to :chat
      t.belongs_to :user
    end
  end
end
