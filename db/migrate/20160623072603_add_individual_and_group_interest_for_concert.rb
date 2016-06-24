class AddIndividualAndGroupInterestForConcert < ActiveRecord::Migration[5.0]
  def up
    add_column :interests, :individual, :boolean
    add_column :interests, :group, :boolean
  end

  def down
    remove_column :interests, :individual
    remove_column :interests, :group
  end
end
