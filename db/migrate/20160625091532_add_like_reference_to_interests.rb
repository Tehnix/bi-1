class AddLikeReferenceToInterests < ActiveRecord::Migration[5.0]
  def change
    add_reference :interests, :like
  end
end
