class SetDefaultAttendedinSavedConcerts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :saved_concerts, :attended, default: false
  end
end
