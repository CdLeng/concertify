class AddTicketMasterIdToConcerts < ActiveRecord::Migration[7.0]
  def change
    add_column :concerts, :tm_id, :string
  end
end
