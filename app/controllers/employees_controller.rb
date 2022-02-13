class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    render :show
  end

  def show
  end
end
