require "rails_helper"
RSpec.describe Employee do
  context "soft destroy" do
    it "sets deleted_at" do
      employee = create(:employee)
      employee.soft_destroy

      actual_employee = Employee.find(employee.id)

      expect(actual_employee.deleted_at).to be_within(5.seconds).of(Time.zone.now)
    end

    it "does not change deleted_at, when the record is allready deleted" do
      old_timestamp = 1.days.ago
      employee = create(:employee, deleted_at: old_timestamp)
      employee.soft_destroy

      actual_employee = Employee.find(employee.id)

      expect(actual_employee.deleted_at).to be_within(1.seconds).of(old_timestamp) # mysql cuts some ms
    end

    it "returns 'true' when a record is deleted" do
      employee = create(:employee, deleted_at: Time.zone.now)
      expect(employee.deleted?).to be_truthy
    end

    it "returns 'false' when a record is not deleted" do
      employee = create(:employee, deleted_at: nil)
      expect(employee.deleted?).to be_falsey
    end
  end

  it "returns the participation for the current lunch" do
    lunch = create :lunch, :with_participants
    employee = Employee.first

    expect(employee.current_participation.lunch).to eq lunch
  end
end
