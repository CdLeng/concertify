class AddImageToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :image_url, :string
  end
end
