class ChangeAttentedForConcerts < ActiveRecord::Migration[7.0]
  def change
    change_column :saved_concerts, :attended, :boolean, default: false
  end
end
