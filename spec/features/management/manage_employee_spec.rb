require "rails_helper"

RSpec.feature "Manage employees" do
  scenario "create an employee" do
    visit new_employee_path

    fill_in "Name", with: "My foobar"
    select "development", from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create employee"
  end
end
