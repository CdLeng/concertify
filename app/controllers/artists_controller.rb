class ArtistsController < ApplicationController
  require 'open-uri'
  include HTTParty

  helper_method :create_artist

  def index
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

  private

  def create_artist(artist)
    @new_artist = Artist.new
    @new_artist.name = artist["name"]
    # artist_description(artist["name"])
    @new_artist.description = @description
    @new_artist.save
    # redirect_to artist_path(@new_artist)
  end

  # def artist_description(artist)
  #   artists_url = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{artist}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
  #   serialized = URI.open(artists_url).read
  #   user = JSON.parse(serialized)
  #   @description = user["artist"]["bio"]["summary"]
  # end

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
