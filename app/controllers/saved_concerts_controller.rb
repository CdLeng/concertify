class SavedConcertsController < ApplicationController

  def index
    @saved_concerts = SavedConcert.all
    @saved_concerts = policy_scope(SavedConcert)
  end
end
