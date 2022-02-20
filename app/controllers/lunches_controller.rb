class LunchesController < ApplicationController
  def index
    redirect_to lunch_path Lunch.current_lunch
  end

  def show
    lunch = Lunch.includes(participants: :employee).find(params[:id])
    @current_department = Employee.valid_department?(params[:department]) ? params[:department] : nil
    @current_lunch_id = lunch.id
    @previous_lunch_id = lunch.previous_lunch&.id
    @next_lunch_id = lunch.next_lunch&.id
    @title = lunch.title

    @pairs = lunch.pairs @current_department
  end
end
