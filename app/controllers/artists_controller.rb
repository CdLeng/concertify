class ArtistsController < ApplicationController
  require 'open-uri'
  include HTTParty

  def index
    @artist = Artist.new
    if params[:query].present?
      return_artists(params[:query])
      @artists = policy_scope(Artist).search_by_artist(params[:query])
    else
      @artists = policy_scope(Artist).all
    end
  end

  def show
    @artist = Artist.find(params[:id])
    authorize @artist
  end

  def create
    artist_params(params["artist"])
    @artist = Artist.find_by(spotify_id: @spotify_id)
    if @artist
      authorize @artist
      redirect_to artist_path(@artist)
    else
      set_artist
      if @artist_genres
        artist_genres
      end
      redirect_to artist_path(@new_artist)
    end
  end

  private

  def artist_params(params)
    @spotify_id = params["spotify_id"]
    @artist_name = params["name"]
    @artist_img = params["image_url"]
    @artist_genres = params["genres"]
  end

  def set_artist
    @new_artist = Artist.new
    authorize @new_artist
    @new_artist.spotify_id = @spotify_id
    @new_artist.name = @artist_name
    artist_description(@artist_name)
    @new_artist.description = @artist_description
    @new_artist.image_url = @artist_img
    @new_artist.save
  end

  def artist_genres
    @artist_genres.split.each do |genre|
      unless Genre.find_by(name: genre)
        @new_genre = Genre.create(name: genre)
      end
      @artist_genre = ArtistGenre.new
      @artist_genre.artist = @new_artist
      @artist_genre.genre = @new_genre
      @artist_genre.save
    end
  end

  def artist_description(artist_name)
    url_encoded_string = CGI::escape(artist_name)
    artist_url = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{url_encoded_string}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
    serialized = URI.parse(artist_url).read
    user = JSON.parse(serialized)
    @artist_description = user["artist"]["bio"]["summary"]
  end

  def return_artists(query)
    encoded_query = CGI::escape(query)
    @auth_url = 'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'
    @auth_response = URI.parse(@auth_url).read
    @auth_json = JSON.parse(@auth_response)
    @auth_code = @auth_json["accessToken"]
    @headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@auth_code}"
    }
    @response = HTTParty.get("https://api.spotify.com/v1/search?q=#{encoded_query}&type=artist&limit=35", headers: @headers)
    @results = @response["artists"]["items"]
  end
end
