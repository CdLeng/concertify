class AddReferenceToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_reference :concerts, :artist, null: false, foreign_key: true
  end
end
