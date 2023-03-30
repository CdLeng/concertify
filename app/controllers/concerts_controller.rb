class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @user = current_user
    if @user
      @user_saved = @user.saved_concerts
      @user_save = @user_saved.find_by(concert_id: params[:id], user_id: @user).nil?
    end
    @concert = Concert.find(params[:id])

    authorize @concert

    @markers = [{
          lat: @concert.latitude,
          lng: @concert.longitude,
          info_window_html: render_to_string(partial: "popup", locals: { concert: @concert })
         }]
  end

  def index
    @concerts = policy_scope(Concert)
    @concerts = Concert.all
    user = current_user
    @followed_artists = user.followed_artists

    @filtered_concerts = Concert.near("#{user.address}, #{user.city}, #{user.country_code}", 200)

    concerts_by_artist = @filtered_concerts.group_by(&:artist)
    @one_concert_per_artist = concerts_by_artist.map { |artist, concerts| concerts.last }

    @followed_concerts = []

    @one_concert_per_artist.each do |concert|
      @followed_artists.each do |fa|
        if fa.artist == concert.artist
          @followed_concerts << concert
        end
      end
    end

    @markers = @followed_concerts.map do |concert|
      {
        lat: concert.latitude,
        lng: concert.longitude,
        info_window_html: render_to_string(partial: "popup", locals: {concert: concert})
      }
    end

  end
end
