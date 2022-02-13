class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    flash[:notice] = "Employee 'My foobar' created."
    redirect_to employee_path(current_employee)
  end

  def edit
  end

  def update
    flash[:notice] = "Employee 'My foobar2' updated."
    redirect_to employee_path(current_employee)
  end

  def show
  end

  private

  def current_employee
    @employee ||= Employee.new name: "My foobar", department: "development", id: 1
  end
  helper_method :current_employee
end
