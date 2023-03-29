class FollowedArtistsController < ApplicationController
  def index
    @followed_artists = policy_scope(FollowedArtist)
    @followed_artists = current_user.followed_artists
  end

  def create
    @followed_artist = FollowedArtist.new
    @followed_artist.artist = Artist.find(params[:artist_id])
    @followed_artist.user = current_user
    authorize @followed_artist

    if @followed_artist.save!
      redirect_to followed_artists_path, notice: "This artist was added to favourites."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
