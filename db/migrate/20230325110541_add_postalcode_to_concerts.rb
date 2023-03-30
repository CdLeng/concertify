class AddPostalcodeToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :postal_code, :string
  end
end
