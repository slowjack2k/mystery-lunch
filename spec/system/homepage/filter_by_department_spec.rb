require "rails_helper"

RSpec.feature "Filter lunch pairings", type: :system do
  def create_participants(lunch, lunch_group, departments)
    departments.map do |department|
      employee = create :employee, department: department
      create(:participant, lunch: lunch, employee: employee, lunch_group: lunch_group)
    end
  end

  scenario "show only lunch pairings for a given department" do
    lunch = create :lunch

    wanted_participants = create_participants lunch, "group-1", %w[development HR]
    wanted_participants.push(*create_participants(lunch, "group-2", %w[development data]))

    create_participants lunch, "group-3", %w[HR data]

    expected_employees = wanted_participants.map(&:employee)
      .map(&:attributes)
      .map { |attrs| attrs.slice("id", "department", "name") }
      .map { |participant_attrs| {identifier: "participant-#{participant_attrs.delete "id"}", data: participant_attrs.values} }

    visit lunch_path(lunch, department: "development")

    expect(page).to have_text "Lunch 1 / 2022"

    expect(page).to contain_cards_with expected_employees, class: "participant"
  end
end
