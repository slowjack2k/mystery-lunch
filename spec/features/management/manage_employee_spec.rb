require "rails_helper"

RSpec.feature "Manage employees" do
  def username
    ENV.fetch("BASIC_AUTH_USER")
  end

  def password
    ENV.fetch("BASIC_AUTH_PASSWORD")
  end

  def login(username, password)
    page.driver.browser.basic_authorize(username, password)
  end

  scenario "create an employee" do
    employee_attrs = attributes_for(:employee)

    login(username, password)
    visit new_employee_path

    fill_in "Name", with: employee_attrs[:name]
    select employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create Employee"

    expect(page).to have_text "Employee '#{employee_attrs[:name]}' created."
  end

  scenario "show an employee" do
    employee = create(:employee)

    login(username, password)
    visit employee_path(employee)

    expect(page).to have_text("Name:").and have_text(employee.name)
  end

  scenario "edit an employee" do
    employee = create(:employee)
    new_employee_attrs = attributes_for(:employee, department: "data")

    login(username, password)
    visit edit_employee_path(employee)

    expect(page).to have_field("Name", with: employee.name).and have_select("Department",
      selected: employee.department)

    fill_in "Name", with: new_employee_attrs[:name]
    select new_employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Update Employee"

    expect(page).to have_text "Employee '#{new_employee_attrs[:name]}' updated."
  end

  scenario "show all employees" do
    5.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }

    expected_table_md = <<~'EOF'
      | # | Name   | Department  | Actions      |
      | * | name-1 | development | Show \| Edit |
      | * | name-2 | development | Show \| Edit |  
      | * | name-3 | development | Show \| Edit |   
      | * | name-4 | development | Show \| Edit |   
      | * | name-5 | development | Show \| Edit |
    EOF

    login(username, password)
    visit employees_path

    expect(page).to contain_table(expected_table_md)
  end

  scenario "an unauthenticated user gets access denied" do
    login(username, "does not exists")

    visit new_employee_path
    expect(page).to have_http_status(401)

    employee = create(:employee)

    visit employee_path(employee)

    expect(page).to have_http_status(401)

    visit edit_employee_path(employee)

    expect(page).to have_http_status(401)

    visit employees_path

    expect(page).to have_http_status(401)
  end
end
