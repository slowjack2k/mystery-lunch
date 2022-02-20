class LunchesController < ApplicationController
  def index
    redirect_to lunch_path Lunch.last
  end

  def show
    lunch = Lunch.includes(participants: :employee).find(params[:id])
    @title = lunch.title

    @pairs = lunch.pairs
  end
end
