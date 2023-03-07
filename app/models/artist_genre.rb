class ArtistGenre < ApplicationRecord
  belongs_to :artist
  belongs_to :genre
  validates :artist_id, uniqueness: {
    scope: [:genre_id]
  }
end
