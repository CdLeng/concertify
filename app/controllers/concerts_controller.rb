class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def show
    @concert = Concert.find(params[:id])

    authorize @concert

    @markers = [ {
          lat: @concert.latitude,
          lng: @concert.longitude,
          info_window_html: render_to_string(partial: "popup", locals: {concert: @concert})
        } ]


  end

  def index
    @concerts = policy_scope(Concert)
    @concerts = Concert.all

    @markers = @concerts.geocoded.map do |concert|
      {
        lat: concert.latitude,
        lng: concert.longitude,
        info_window_html: render_to_string(partial: "popup", locals: {concert: concert})
      }

    end
  end
end
