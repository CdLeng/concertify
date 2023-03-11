class SavedConcertsController < ApplicationController

  def index
    @saved_concerts = SavedConcert.all
    @saved_concerts = policy_scope(SavedConcert)
  end

  def create
    authorize @saved_concert
    @saved_concert = SavedConcert.create!(params[:concert_id])

    if @saved_concert.save!
      redirect_to saved_concert_path(@saved_concert), notice: "This concert was succesfully saved."
    else
      render "concerts/show", status: :unprocessable_entity
    end
  end
end
