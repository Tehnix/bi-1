class ChangeMessageAuthorToUserReference < ActiveRecord::Migration[5.0]
  def up
    change_column :messages, :author, :integer
    rename_column :messages, :author, :author_id
  end

  def down
    rename_column :messages, :author_id, :author
    change_column :messages, :author, :string
  end
end
