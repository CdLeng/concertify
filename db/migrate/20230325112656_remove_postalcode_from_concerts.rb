class RemovePostalcodeFromConcerts < ActiveRecord::Migration[7.0]
  def change
    remove_column :concerts, :postal_code, :string
  end
end
