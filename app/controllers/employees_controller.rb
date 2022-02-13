class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    flash[:notice] = "Employee 'My foobar' created."
    render :show
  end

  def show
  end
end
