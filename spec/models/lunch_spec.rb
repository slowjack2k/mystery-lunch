require "rails_helper"
RSpec.describe Lunch do
  it "returns the employees grouped by lunch pair" do
    lunch = create :lunch
    expected_result = {
      "group-1" => create_list(:participant, 2, lunch: lunch, lunch_group: "group-1").map(&:employee),
      "group-2" => create_list(:participant, 2, lunch: lunch, lunch_group: "group-2").map(&:employee)
    }

    expect(lunch.pairs).to eq(expected_result)
  end
end
