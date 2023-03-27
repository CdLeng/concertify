class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    authorize @user

    @saved_concerts = @user.saved_concerts

    @followed_artists = @user.followed_artists

    @genres = Genre.all
  end
end
