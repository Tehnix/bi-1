class RenameContentToText < ActiveRecord::Migration[5.0]
  def up
    rename_column :messages, :content, :text
  end

  def down
    rename_column :messages, :text, :content
  end
end
