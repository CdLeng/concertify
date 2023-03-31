class Artist < ApplicationRecord
  has_many :concerts
  has_many :artist_genres, dependent: :destroy
  has_many :genres, through: :artist_genres
  has_many :concerts, dependent: :destroy
  has_many :followed_artist, dependent: :destroy
  validates :name, presence: true
  validates :description, length: { maximum: 5000 }
  # validates :spotify_id, presence: true, uniqueness: true

  include PgSearch::Model

  pg_search_scope :search_by_artist,
    against: [ :name, :description ],
    using: {
      tsearch: { prefix: true }
    }
end
