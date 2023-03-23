class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def show
    @concert = Concert.find(params[:id])
    authorize @concert
  end

  def index
    @concerts = policy_scope(Concert)
    @concerts = Concert.all.first(8)
  end
end
