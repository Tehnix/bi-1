class CreateConcertsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.references :concert, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
