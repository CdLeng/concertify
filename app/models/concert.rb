class Concert < ApplicationRecord
  belongs_to :artist
  has_many :saved_concerts, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_nil: true
  validates :description, length: { maximum: 5000 }
  validates :tm_id, uniqueness: true

  reverse_geocoded_by :latitude, :longitude
end
