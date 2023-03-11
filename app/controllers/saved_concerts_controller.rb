class SavedConcertsController < ApplicationController

  def create
    authorize @saved_concert
    @saved_concert = SavedConcert.create!(params[:id])

    if @saved_concert.save!
      redirect_to saved_concert_path(@saved_concert), notice: "This concert was succesfully saved."
    else
      render "concerts/show", status: :unprocessable_entity
    end
  end
end
