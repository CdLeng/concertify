class ChangeArtistDescriptionToText < ActiveRecord::Migration[7.0]
  def change
    change_column :artists, :description, :text
  end
end
