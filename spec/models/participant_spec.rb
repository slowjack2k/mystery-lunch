require "rails_helper"
RSpec.describe Participant do
  def create_participants(lunch, lunch_group, departments)
    departments.map do |department|
      employee = create :employee, department: department
      create(:participant, lunch: lunch, employee: employee, lunch_group: lunch_group)
    end
  end

  it "returns all other partners of a lunch group" do
    lunch = create :lunch
    all_participants = create_participants lunch, "group-1", %w[development HR data]
    all_participants.shuffle

    participant = all_participants.shift

    expect(participant.peers).to eq all_participants
  end
end
