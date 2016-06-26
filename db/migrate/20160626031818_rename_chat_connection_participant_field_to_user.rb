class RenameChatConnectionParticipantFieldToUser < ActiveRecord::Migration[5.0]
  def up
    rename_column :chat_connections, :participant_id, :user_id
  end

  def down
    rename_column :chat_connections, :user_id, :participant_id
  end
end
