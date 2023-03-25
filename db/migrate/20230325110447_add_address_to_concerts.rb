class AddAddressToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :address, :string
  end
end
