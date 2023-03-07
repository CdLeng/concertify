class Artist < ApplicationRecord
  has_many :concerts, dependent: :destroy

  validates :name, presence: true
end
