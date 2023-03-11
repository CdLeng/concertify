class FollowedArtistsController < ApplicationController
  def index
    @followed_artists = policy_scope(FollowedArtist)
    @followed_artists = FollowedArtist.all
  end
end
