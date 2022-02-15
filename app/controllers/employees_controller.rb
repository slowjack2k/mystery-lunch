class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new employee_params

    if @employee.save
      flash[:notice] = "Employee '#{@employee.name}' created."
      redirect_to employee_path(current_employee)
    else
      flash[:error] = "Employee #{@employee.name}' not created."
      render :new
    end
  end

  def edit
  end

  def update
    if current_employee.update(employee_params)
      flash[:notice] = "Employee '#{current_employee.name}' updated."
      redirect_to employee_path(current_employee)
    else
      flash[:error] = "Employee #{@employee.name}' not updated."
      render :edit
    end
  end

  def show
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :department).tap do |p|
      p.transform_values! { |v| ActionController::Base.helpers.sanitize v }
    end
  end

  def current_employee
    @employee ||= Employee.find(params[:id])
  end
  helper_method :current_employee
end
