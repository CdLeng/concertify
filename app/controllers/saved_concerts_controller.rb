class SavedConcertsController < ApplicationController
  def index
    @saved_concerts = policy_scope(SavedConcert)
    @saved_concerts = SavedConcert.all
  end

  def create
    @saved_concert = SavedConcert.new
    @saved_concert.concert = Concert.find(params[:concert_id])
    @saved_concert.user = current_user
    authorize @saved_concert

    if @saved_concert.save!
      redirect_to saved_concerts_path, notice: "This concert was succesfully saved."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
