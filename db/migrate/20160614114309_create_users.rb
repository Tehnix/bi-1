class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :session_token
      t.string :name
      t.references :chats
      t.references :messages

      t.timestamps
    end
  end
end
