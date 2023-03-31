class SavedConcertsController < ApplicationController
  def index
    @saved_concerts = policy_scope(SavedConcert)
    @saved_concerts = current_user.saved_concerts
  end

  def create
    @saved_concert = SavedConcert.new
    @saved_concert.concert = Concert.find(params[:concert_id])
    @saved_concert.user = current_user
    authorize @saved_concert

    if @saved_concert.save!
      redirect_to concert_path(@saved_concert.concert), notice: "This concert was succesfully saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    @concert = Concert.find(params[:id])
    @saved_concert = SavedConcert.find_by(concert_id: @concert, user_id: current_user)
    authorize @saved_concert
    @saved_concert.destroy
    source = params[:source]
    if source
      redirect_to saved_concerts_path, notice: "This concert is no longer on your saved concerts."
    else
      redirect_to concert_path(@concert), notice: "This concert is no longer saved."
    end
  end
end
