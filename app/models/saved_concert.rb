class SavedConcert < ApplicationRecord
  belongs_to :concert
  belongs_to :user
  validates :concert_id, uniqueness: {
    scope: [:user_id] }
end
