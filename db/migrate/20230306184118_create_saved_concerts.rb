class CreateSavedConcerts < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_concerts do |t|
      t.boolean :attended
      t.references :concert, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
