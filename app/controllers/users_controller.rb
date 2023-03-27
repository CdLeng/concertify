class UsersController < ApplicationController
  require 'open-uri'
  include HTTParty

  def show
    @user = User.find(params[:id])
    authorize @user
    @saved_concerts = SavedConcert.all
    @followed_artists = FollowedArtist.all
    @genres = Genre.all
  end

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Now you can access user's private data, create playlists and much more

    auth_token = spotify_user.credentials.token
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{auth_token}"
    }
    response = HTTParty.get("https://api.spotify.com/v1/me/following?type=artist", headers: headers)
    @followed_spotify_artists = response["artists"]["items"]
    @user = current_user
    authorize @user
    create_artists
    artist_description
    redirect_to followed_artists_path
  end

  private

  def create_artists
    @followed_spotify_artists.each do |artist|
      spotify_id = artist["id"]
      @artist_name = artist["name"]
      artist_img = artist["images"][0]["url"]
      @artist = Artist.find_by(spotify_id: spotify_id)
      if @artist
        followed_artist = FollowedArtist.new
        followed_artist.artist = @artist
        followed_artist.user = current_user
        followed_artist.save
      else
        @artist_genres = artist["genres"]
        @artist = Artist.new
        @artist.spotify_id = spotify_id
        @artist.name = @artist_name
        artist_description
        @artist.description = @artist_description
        @artist.image_url = artist_img
        @artist.save
        followed_artist = FollowedArtist.new
        followed_artist.artist = @artist
        followed_artist.user = current_user
        followed_artist.save
        artist_genres
      end
    end
  end

  def artist_genres
    @artist_genres.each do |genre|
      genre_found = Genre.find_by(name: genre)
      @artist_genre = ArtistGenre.new
      @artist_genre.artist = @artist
      if genre_found
        @artist_genre.genre = genre_found
        @artist_genre.artist = @artist
      else
        @new_genre = Genre.create(name: genre)
        @artist_genre.artist = @artist
        @artist_genre.genre = @new_genre
      end
      @artist_genre.save
    end
  end

  def artist_description
    url_encoded_string = CGI::escape(@artist_name)
    artist_url = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{url_encoded_string}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
    serialized = URI.parse(artist_url).read
    user = JSON.parse(serialized)
    @artist_description = user["artist"]["bio"]["summary"]
  end
end
