require "rails_helper"

RSpec.describe DestroyEmployeeService do
  def create_employees(cnt = 6)
    cnt.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }
  end

  it "deletes an employee with a soft delete" do
    create_employees

    expect do
      current_employee = Employee.all.sample
      DestroyEmployeeService.call(employee: current_employee)
    end.to change { Employee.where.not(deleted_at: nil).count }.by(1)
  end

  it "for even count employees it redistributes the peer" do
    create_employees

    MysteryPartnerSelectionService.call year: 1, month: 1

    current_employee = Employee.all.sample
    current_group = current_employee.current_participation.lunch_group

    expect do
      DestroyEmployeeService.call(employee: current_employee)
    end.to change { Participant.where(lunch_group: current_group).where.not(employee: current_employee).count }.from(1).to(0)
  end

  it "for odd count employees it removes only the deleted employee" do
    create_employees(5)

    MysteryPartnerSelectionService.call year: 1, month: 1

    current_employee = Employee.all.sample
    current_group = current_employee.current_participation.lunch_group

    expect do
      DestroyEmployeeService.call(employee: current_employee)
    end.not_to change { Participant.where(lunch_group: current_group).where.not(employee: current_employee).count }
  end
end
