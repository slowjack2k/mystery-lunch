require "rails_helper"

RSpec.feature "Manage employees" do
  scenario "create an employee" do
    employee_attrs = attributes_for(:employee)

    visit new_employee_path

    fill_in "Name", with: employee_attrs[:name]
    select employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create Employee"

    expect(page).to have_text "Employee '#{employee_attrs[:name]}' created."
  end

  scenario "show an employee" do
    employee = create(:employee)

    visit employee_path(employee)

    expect(page).to have_text("Name:").and have_text(employee.name)
  end

  scenario "edit an employee" do
    employee = create(:employee)
    new_employee_attrs = attributes_for(:employee, department: "data")

    visit edit_employee_path(employee)

    expect(page).to have_field("Name", with: employee.name).and have_select("Department",
      selected: employee.department)

    fill_in "Name", with: new_employee_attrs[:name]
    select new_employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Update Employee"

    expect(page).to have_text "Employee '#{new_employee_attrs[:name]}' updated."
  end
end
