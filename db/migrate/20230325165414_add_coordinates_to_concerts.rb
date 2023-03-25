class AddCoordinatesToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :latitude, :float
    add_column :concerts, :longitude, :float
  end
end
