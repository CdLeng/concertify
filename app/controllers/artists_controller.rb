class ArtistsController < ApplicationController
  require 'open-uri'
  include HTTParty

  helper_method :create_artist

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
    @artist_name = params["artist"]["name"]
    @artist_img = params["artist"]["image_url"]
    @artist_genres = params["artist"]["genres"].split
    @artist = Artist.find_by(name: @artist_name)
    if @artist
      redirect_to artist_path(@artist)
    else
      @new_artist = Artist.new
      authorize @new_artist
      @new_artist.name = params["artist"]["name"]
      artist_description(@artist_name)
      @new_artist.description = @description
      @new_artist.image_url = @artist_img
      @new_artist.save
      @artist_genres.each do |genre|
        unless Genre.find_by(name: genre)
          @new_genre = Genre.create(name: genre)
        end
        @artist_genre = ArtistGenre.new
        @artist_genre.artist = @new_artist
        @artist_genre.genre = @new_genre
        @artist_genre.save
      end
      redirect_to artist_path(@new_artist)
    end
  end

  private

  def artist_description(artist_name)
    artists_url = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{artist_name}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
    serialized = URI.open(artists_url).read
    user = JSON.parse(serialized)
    @description = user["artist"]["bio"]["summary"]
  end

  def return_artists(query)
    @auth_url = 'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'
    @auth_response = URI.open(@auth_url).read
    @auth_json = JSON.parse(@auth_response)
    @auth_code = @auth_json["accessToken"]
    @headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@auth_code}"
    }
    @response = HTTParty.get("https://api.spotify.com/v1/search?q=#{query}&type=artist&limit=35", headers: @headers)
    @results = @response["artists"]["items"]
  end
end
