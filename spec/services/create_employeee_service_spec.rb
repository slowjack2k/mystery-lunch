require "rails_helper"

RSpec.describe CreateEmployeeService do
  def create_employees(cnt = 6)
    cnt.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }
  end

  it "creates a new employee" do
    params = attributes_for :employee
    expect do
      CreateEmployeeService.call params: params
    end.to change { Employee.count }.by 1
  end

  it "adds the employee to an existing lunch pair" do
    create :lunch, :with_participants

    params = attributes_for :employee
    expect do
      CreateEmployeeService.call params: params
    end.to change { Participant.count }.by 1
  end
end
