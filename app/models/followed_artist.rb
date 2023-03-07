class FollowedArtist < ApplicationRecord
  belongs_to :artist
  belongs_to :user
  validates :artist_id, uniqueness: {
    scope: [:user_id]
  }
end
