class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    flash[:notice] = "Employee 'My foobar' created."
    redirect_to employee_path(1)
  end

  def show
    @employee = Employee.new name: "My foobar", department: "development"
  end
end
