class Concert < ApplicationRecord
  belongs_to :artist
  has_one :saved_concert, dependent: :destroy
  validates :location, presence: true
  validates :date, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 5000 }
end
