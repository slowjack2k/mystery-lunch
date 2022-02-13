require "rails_helper"

RSpec.feature "Manage employees" do
  scenario "create an employee" do
    visit new_employee_path

    fill_in "Name", with: "My foobar"
    select "development", from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create employee"

    expect(page).to have_text "Employee 'My foobar' created."
  end

  scenario "show an employee" do
    visit employee_path(1)

    expect(page).to have_text "Name:"
    expect(page).to have_text "My foobar"
  end
end
