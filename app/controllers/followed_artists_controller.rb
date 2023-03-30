class FollowedArtistsController < ApplicationController
  def index
    @followed_artists = policy_scope(FollowedArtist)
    @followed_artists = current_user.followed_artists
  end

  def create
    @user = current_user
    @followed_artist = FollowedArtist.new
    @followed_artist.artist = Artist.find(params[:artist_id])
    @followed_artist.user = current_user
    authorize @followed_artist

    if @followed_artist.save!
      redirect_to artist_path(@followed_artist.artist), notice: "This artist was added to favourites."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    @artist = Artist.find(params[:id])
    @followed_artist = FollowedArtist.find_by(artist_id: @artist, user_id: current_user)
    authorize @followed_artist
    @followed_artist.destroy
    source = params[:source]
    if source
      redirect_to followed_artists_path, notice: "You are no longer following #{@artist.name}."
    else
      redirect_to artist_path(@artist), notice: "You are no longer following #{@artist.name}."
    end
  end
end
