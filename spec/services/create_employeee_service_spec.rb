require "rails_helper"

RSpec.describe CreateEmployeeService do
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

  it "sends an email to all participants" do
    create :lunch, :with_participants

    params = attributes_for :employee
    expect do
      CreateEmployeeService.call params: params
    end.to change { ActionMailer::Base.deliveries.count }
  end
end
