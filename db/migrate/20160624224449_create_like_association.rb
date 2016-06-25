class CreateLikeAssociation < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.belongs_to :user
      t.belongs_to :stranger
    end

    add_reference :users, :like
  end
end
