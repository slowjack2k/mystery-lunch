class LunchesController < ApplicationController
  def index
    redirect_to lunch_path Lunch.last
  end

  def show
    lunch = Lunch.includes(participants: :employee).find(params[:id])
    @current_department = Employee.valid_department?(params[:department]) ? params[:department] : nil
    @lunch_id = lunch.id
    @title = lunch.title

    @pairs = lunch.pairs @current_department
  end
end
