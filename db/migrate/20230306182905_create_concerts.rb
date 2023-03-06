class CreateConcerts < ActiveRecord::Migration[7.0]
  def change
    create_table :concerts do |t|
      t.string :location
      t.string :description
      t.date :date
      t.float :price
      t.string :ticket_url

      t.timestamps
    end
  end
end
