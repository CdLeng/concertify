class Concert < ApplicationRecord
  belongs_to :artist
  has_many :saved_concerts
end
