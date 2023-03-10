class ConcertsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @concerts = policy_scope(Concert)
    @concerts = Concert.all
  end
end
