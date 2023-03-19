class ArtistsController < ApplicationController

  def index
    @artist = Artist.new
    if params[:query].present?
      @artists = policy_scope(Artist).search_by_artist(params[:query])
    else
      @artists = policy_scope(Artist).all
    end
  end

  def show
    @artist = Artist.find(params[:id])
    authorize @artist
  end
end
