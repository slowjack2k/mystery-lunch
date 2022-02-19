require "rails_helper"

RSpec.feature "display current lunch", type: :system do
  def create_participants_for(lunch, group_name)
    create_list(:participant, 2, lunch: lunch, lunch_group: group_name)
      .map(&:employee)
      .map(&:attributes)
      .map { |attrs| attrs.slice("id", "department", "name") }
      .map { |participant_attrs| {identifier: "participant-#{participant_attrs.delete "id"}", data: participant_attrs.values} }
  end

  scenario "show all lunch pairings" do
    lunch = create :lunch
    expected_result = create_participants_for(lunch, "group-1") + create_participants_for(lunch, "group-2")

    visit lunches_path

    expect(page).to have_text "Lunch 1 / 2022"

    expect(page).to contain_cards_with expected_result, class: "participant"
  end
end
