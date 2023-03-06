class Genre < ApplicationRecord
  has_many :artist_genres
  validates :name, uniqueness: true
end
