class RemoveAttractionIdFromConcerts < ActiveRecord::Migration[7.0]
  def change
    remove_column :concerts, :attraction_id, :string
  end
end
