require "rails_helper"

RSpec.feature "Navigate through lunches", type: :system do
  def create_participants_for(lunch, group_name)
    create_list(:participant, 2, lunch: lunch, lunch_group: group_name)
      .map(&:employee)
      .map(&:attributes)
      .map { |attrs| attrs.slice("id", "department", "name") }
      .map { |participant_attrs| {identifier: "participant-#{participant_attrs.delete "id"}", data: participant_attrs.values} }
  end

  scenario "Show previous pairings" do
    lunch = create :lunch, year: 2020, month: 1
    expected_result_page2 = create_participants_for(lunch, "group-1") + create_participants_for(lunch, "group-2")

    lunch = create :lunch, year: 2020, month: 2
    expected_result_page1 = create_participants_for(lunch, "group-1") + create_participants_for(lunch, "group-2")

    visit root_path

    expect(page).to have_text "Lunch 2 / 2020"

    expect(page).to contain_cards_with expected_result_page1, class: "participant"

    click_link "Previous Lunch"

    expect(page).to have_text "Lunch 1 / 2020"

    expect(page).to contain_cards_with expected_result_page2, class: "participant"
  end

  scenario "Show next pairings" do
    lunch1 = create :lunch, year: 2020, month: 1
    expected_result_page2 = create_participants_for(lunch1, "group-1") + create_participants_for(lunch1, "group-2")

    lunch2 = create :lunch, year: 2020, month: 2
    expected_result_page1 = create_participants_for(lunch2, "group-1") + create_participants_for(lunch2, "group-2")

    visit lunch_path lunch1.id

    expect(page).to have_text "Lunch 1 / 2020"

    expect(page).to contain_cards_with expected_result_page2, class: "participant"

    click_link "Next Lunch"

    expect(page).to have_text "Lunch 2 / 2020"

    expect(page).to contain_cards_with expected_result_page1, class: "participant"
  end
end
