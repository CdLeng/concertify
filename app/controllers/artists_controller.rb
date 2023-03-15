class ArtistsController < ApplicationController
  require 'open-uri'
  require 'httparty'
  def index
    if params[:query].present?
      return_artists
      return_artists_img(params[:query])
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

  def return_artists
    artists_url = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{params[:query]}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
    serialized = URI.open(artists_url).read
    user = JSON.parse(serialized)
    @results = user["results"]["artistmatches"]["artist"]
  end

  def return_artists_img(query)
    auth_url = 'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'
    auth_response = URI.open(auth_url).read
    auth_json = JSON.parse(auth_response)
    @auth_code = auth_json["accessToken"]
    @img_response = URI.open("https://api.spotify.com/v1/search?q=#{query}&include_external=audio",
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@auth_code}") {|f|
        # ...
      }.read
    img_json = JSON.parse(img_response)
    @images = img_json["artists"]["images"]
  end
end
