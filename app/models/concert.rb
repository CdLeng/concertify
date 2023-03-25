class Concert < ApplicationRecord
  belongs_to :artist
  has_many :saved_concerts, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 5000 }

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
