class ArtistsController < ApplicationController

  def index
    @artists = Artist.all
    @artists = policy_scope(Artist)
  end
end
