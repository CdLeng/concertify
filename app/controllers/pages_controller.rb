class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @artists = Artist.joins(:concerts).distinct
    @concerts_highlight = @artists.sample(3)
    @concerts = Concert.first(3)
    @artist_array = []
    @artists.each do |artist|
      @artist_array.push(artist.name)
    end
  end
end
