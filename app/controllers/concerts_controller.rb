class ConcertsController < ApplicationController

  def show
    authorize @concert
    @concert = Concert.find(params[:id])
  end
end
