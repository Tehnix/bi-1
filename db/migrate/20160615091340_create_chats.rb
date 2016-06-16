class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.string :type
      t.references :user, foreign_key: true
      t.references :concert, foreign_key: true
      t.string :unread_count

      t.timestamps
    end
  end
end
