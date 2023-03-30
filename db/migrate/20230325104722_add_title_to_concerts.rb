class AddTitleToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :title, :string
  end
end
