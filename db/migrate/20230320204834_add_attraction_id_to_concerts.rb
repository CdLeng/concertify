class AddAttractionIdToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :attraction_id, :string
  end
end
