class Genre < ApplicationRecord
  has_many :artist_genres, dependent: :destroy
  validates :name, uniqueness: true
end
