class Artist < ApplicationRecord
  has_many :concerts
  has_many :artist_genres
  has_many :genres, through: :artist_genres
  has_many :concerts, dependent: :destroy
  validates :name, presence: true
end
