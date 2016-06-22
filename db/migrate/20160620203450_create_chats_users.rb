class CreateChatsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :chats_users do |t|
      t.belongs_to :chat
      t.belongs_to :user
    end
  end
end
