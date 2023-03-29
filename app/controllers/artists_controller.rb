class ArtistsController < ApplicationController
  require 'open-uri'
  include HTTParty
  skip_before_action :authenticate_user!, only: [:index, :show, :create]

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
    return_concerts(@artist)
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
    auth_url = 'https://open.spotify.com/get_access_token?reason=transport&productType=web_player'
    auth_response = URI.parse(auth_url).read
    auth_json = JSON.parse(auth_response)
    auth_code = auth_json["accessToken"]
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{auth_code}"
    }
    response = HTTParty.get("https://api.spotify.com/v1/search?q=#{encoded_query}&type=artist&limit=35", headers: headers)
    @results = response["artists"]["items"]
  end

  def return_concerts(artist)
    @artist = artist
    @artist_name = artist.name
    encoded_query = CGI::escape(@artist_name)
    attraction_url = "https://app.ticketmaster.com/discovery/v2/attractions.json?size=5&keyword=#{encoded_query}&apikey=#{ENV["TICKETMASTER_APIKEY"]}"
    attraction_response = URI.parse(attraction_url).read
    attraction_json = JSON.parse(attraction_response)
    unless attraction_json["page"]["totalElements"] == 0
      @attraction_id = attraction_json["_embedded"]["attractions"][0]["id"]
      events_url = "https://app.ticketmaster.com/discovery/v2/events.json?size=10&attractionId=#{@attraction_id}&apikey=#{ENV["TICKETMASTER_APIKEY"]}"
      events_response = URI.parse(events_url).read
      events_json = JSON.parse(events_response)
      unless events_json["page"]["totalElements"] == 0
        concerts = events_json["_embedded"]["events"]
          concerts.each do |c|
            concert_params(c)
            create_concert
          end
      end
    end
  end

  def concert_params(params)
    @concert_title = params["name"]
    @concert_tm_id = params["id"]
    @concert_price = params["priceRanges"] ? params["priceRanges"][0]["min"] : rand(20..100)
    @concert_date = params["dates"]["start"]["localDate"]
    @concert_location = params["_embedded"]["venues"][0]["name"]
    @concert_city = params["_embedded"]["venues"][0]["city"]["name"]
    @concert_country = params["_embedded"]["venues"][0]["country"]["countryCode"]
    @concert_address = params["_embedded"]["venues"][0]["address"] ? params["_embedded"]["venues"][0]["address"]["line1"] : nil
    @concert_latitude = params["_embedded"]["venues"][0]["location"]["latitude"]
    @concert_longitude = params["_embedded"]["venues"][0]["location"]["longitude"]
    @concert_image_url = params["images"][0]["url"]
    @concert_ticket_url = params["url"]
  end

  def create_concert
    @concert_found = Concert.find_by(tm_id: @concert_tm_id)
      unless @concert_found
        new_concert = Concert.new
        new_concert.artist = @artist
        new_concert.title = @concert_title
        new_concert.tm_id = @concert_tm_id
        new_concert.location = @concert_location
        new_concert.address = @concert_address
        new_concert.city = @concert_city
        new_concert.country = @concert_country
        new_concert.latitude = @concert_latitude
        new_concert.longitude = @concert_longitude
        new_concert.date = @concert_date
        new_concert.price = @concert_price
        new_concert.ticket_url = @concert_ticket_url
        new_concert.image_url = @concert_image_url
        new_concert.save
      end
  end
end
