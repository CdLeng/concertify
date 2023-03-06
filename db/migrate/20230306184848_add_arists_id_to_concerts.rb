class AddAristsIdToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_reference :concerts, :artist, foreign_key: true
  end
end
