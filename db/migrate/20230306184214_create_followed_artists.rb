class CreateFollowedArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :followed_artists do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
