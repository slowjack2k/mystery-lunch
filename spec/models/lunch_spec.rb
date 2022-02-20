require "rails_helper"
RSpec.describe Lunch do
  def create_participants(lunch, lunch_group, departments)
    departments.each do |department|
      employee = create :employee, department: department
      create(:participant, lunch: lunch, employee: employee, lunch_group: lunch_group)
    end
  end

  it "returns the employees grouped by lunch pair" do
    lunch = create :lunch
    expected_result = {
      "group-1" => create_list(:participant, 2, lunch: lunch, lunch_group: "group-1").map(&:employee),
      "group-2" => create_list(:participant, 2, lunch: lunch, lunch_group: "group-2").map(&:employee)
    }

    expect(lunch.pairs).to eq(expected_result)
  end

  it "pairings can be filtered by department" do
    lunch = create :lunch

    create_participants lunch, "group-1", %w[development HR]
    create_participants lunch, "group-2", %w[development data]
    create_participants lunch, "group-3", %w[HR data]

    expect(lunch.pairs("development").keys).to eq ["group-1", "group-2"]
  end

  it "changes the lunch group of an existing participation" do
    lunch = create :lunch

    create_participants lunch, "group-1", %w[development HR]

    example_participation = Participant.all.sample

    create_participants lunch, "group-2", %w[development data]

    expect do
      lunch.add_to_different_lunchgroup(example_participation)
    end.to change {
             example_participation.reload
             example_participation.lunch_group
           }.from("group-1").to("group-2")
  end
end
