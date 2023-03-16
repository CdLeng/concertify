class ArtistsController < ApplicationController
  require 'open-uri'
  include HTTParty
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

  def return_artists(query)
    # artists_url = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{params[:query]}&api_key=#{ENV["LASTFM_APIKEY"]}&format=json"
    # serialized = URI.open(artists_url).read
    # user = JSON.parse(serialized)
    # @results = user["results"]["artistmatches"]["artist"]
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
