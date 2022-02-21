class CreateEmployeeService < ApplicationService
  def initialize(params:)
    @params = params
  end

  def call
    instrument "delete_employees" do
      Employee.transaction do
        Employee.new(params).tap do |employee|
          if employee.save
            add_to_existing_pair(employee)
            email_participants [employee.current_participation] + employee.current_participation.peers if employee.current_participation
          end
        end
      end
    end
  end

  private

  def email_participants(participations)
    ParticipationEmailService.call participations: participations
  end

  def add_to_existing_pair(employee)
    Lunch.current_lunch&.create_new_participation_for(employee)
  end

  attr_reader :params
end
