class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @artists = Artist.joins(:concerts).distinct
    @concerts_highlight = @artists.sample(3)
    @concerts = Concert.first(3)
  end
end
