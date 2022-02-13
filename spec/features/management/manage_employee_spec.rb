require "rails_helper"

RSpec.feature "Manage employees" do
  scenario "create an employee" do
    visit new_employee_path

    fill_in "Name", with: "My foobar"
    select "development", from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create Employee"

    expect(page).to have_text "Employee 'My foobar' created."
  end

  scenario "show an employee" do
    visit employee_path(1)

    expect(page).to have_text("Name:").and have_text("My foobar")
  end

  scenario "edit an employee" do
    visit edit_employee_path(1)

    expect(page).to have_field("Name", with: "My foobar").and have_select("Department",
      selected: "development")

    fill_in "Name", with: "My foobar2"
    select "data", from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Update Employee"

    expect(page).to have_text "Employee 'My foobar2' updated."
  end
end
