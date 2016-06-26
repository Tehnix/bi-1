class CreateChatConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_connections do |t|
      t.belongs_to :participant
      t.belongs_to :chat
    end
  end
end
