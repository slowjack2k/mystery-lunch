class CreateEmployeeService < ApplicationService
  def initialize(params:)
    @params = params
  end

  def call
    instrument "delete_employees" do
      Employee.transaction do
        Employee.new(params).tap do |employee|
          add_to_existing_pair(employee) if employee.save
        end
      end
    end
  end

  private

  def add_to_existing_pair(employee)
    Lunch.current_lunch&.create_new_participation_for(employee)
  end

  attr_reader :params
end
