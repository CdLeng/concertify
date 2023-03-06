class Artist < ApplicationRecord
  has_many :concerts
  has_many :followed_concerts
  has_many :artist_genres
end
