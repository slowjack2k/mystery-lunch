class EmployeesController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch("BASIC_AUTH_USER"), password: ENV.fetch("BASIC_AUTH_PASSWORD"), realm: "Mystery lunch"

  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new employee_params

    if @employee.save
      redirect_to employee_path(current_employee), flash: {notice: "Employee '#{@employee.name}' created."}
    else
      render :new, flash: {error: "Employee #{@employee.name}' not created."}
    end
  end

  def edit
  end

  def update
    if current_employee.update(employee_params)
      redirect_to employee_path(current_employee), flash: {notice: "Employee '#{current_employee.name}' updated."}
    else
      render :edit, flash: {error: "Employee #{@employee.name}' not updated."}
    end
  end

  def show
    # deleted employees can be shown
    @employee ||= Employee.find(params[:id])
  end

  def destroy
    # :see_other http://www.railsstatuscodes.com/see_other.html
    # without specs don't work
    if current_employee.soft_destroy
      redirect_to employees_path, status: :see_other, flash: {notice: "Employee was deleted"}
    else
      redirect_to employees_path, status: :see_other, flash: {error: "Employee could not be deleted"}
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :department, :photo).tap do |p|
      p.keys.map(&:to_sym).excluding(:photo).each do |key|
        p[key] = ActionController::Base.helpers.sanitize p[key]
      end
    end
  end

  def current_employee
    @employee ||= Employee.where(deleted_at: nil).find(params[:id])
  end

  helper_method :current_employee
end
