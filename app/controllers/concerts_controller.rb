class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @concert = Concert.find(params[:id])
    authorize @concert
  end

  def index
    @concerts = policy_scope(Concert)
    @concerts = Concert.all
    user = current_user
    @followed_artists = user.followed_artists
  end
end
