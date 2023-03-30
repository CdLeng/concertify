class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
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
    @followed_concerts = []


    @followed_artists.each do |fa|
      if fa.artist.concerts.count>0
        @followed_concerts.push(fa.artist.concerts.last)

      end

    end

    @filtered_concerts = @followed_concerts.sample(8)

    @markers = @filtered_concerts.map do |concert|
      {
        lat: concert.latitude,
        lng: concert.longitude,
        info_window_html: render_to_string(partial: "popup", locals: {concert: concert})
      }
    end

  end
end
