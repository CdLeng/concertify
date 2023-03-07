class Concert < ApplicationRecord
  belongs_to :artist

  validates :location, presence: true
  validates :date, presence: true
  validates :price, numericality: { greater_than: 0 }
end
