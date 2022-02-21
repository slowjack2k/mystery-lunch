require "rails_helper"

RSpec.feature "Manage employees", type: :system do
  def username
    ENV.fetch("BASIC_AUTH_USER")
  end

  def password
    ENV.fetch("BASIC_AUTH_PASSWORD")
  end

  def visit_authenticated(path, username, password)
    visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
    # second call push state workaround with basic auth https://bugs.chromium.org/p/chromium/issues/detail?id=675884
    visit path
  end

  def login(username, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(username, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(username, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(username, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:authorize)
      page.driver.browser.authorize(username, password)
    elsif page.driver.respond_to?(:header)
      encoded_login = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      page.driver.header "Authorization", "Basic #{encoded_login}"
    else
      raise "I don't know how to log in!"
    end
  end

  scenario "create an employee" do
    employee_attrs = attributes_for(:employee)

    login(username, password)
    visit new_employee_path

    fill_in "Name", with: employee_attrs[:name]
    fill_in "Email", with: employee_attrs[:email]
    select employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Create Employee"

    expect(page).to have_text "Employee '#{employee_attrs[:name]}' created."
    expect(page).to have_selector("img[src$='user.png']")
  end

  scenario "show an employee" do
    employee = create(:employee)

    login(username, password)
    visit employee_path(employee)

    expect(page).to have_text("Name:").and have_text(employee.name).and have_text(employee.email)
  end

  scenario "edit an employee" do
    employee = create(:employee)
    new_employee_attrs = attributes_for(:employee, department: "data")

    login(username, password)
    visit edit_employee_path(employee)

    expect(page).to have_field("Name", with: employee.name).and have_select("Department",
      selected: employee.department)

    fill_in "Name", with: new_employee_attrs[:name]
    fill_in "Email", with: new_employee_attrs[:email]
    select new_employee_attrs[:department], from: "Department"
    attach_file("Photo", Rails.root + "spec/fixtures/user.png")

    click_button "Update Employee"

    expect(page).to have_text "Employee '#{new_employee_attrs[:name]}' updated."
  end

  scenario "delete an employee" do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |option|
      option.add_argument("no-sandbox")
      option.add_argument("disable-gpu")
    end

    5.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }

    visit_authenticated employees_path, username, password

    expect do
      current_employee = Employee.all.sample

      within("#employee-#{current_employee.id}") do
        accept_confirm do
          click_link "Delete"
        end
      end

      # wait that deletion is complete
      expect(page).to have_text "Employees"
    end.to change { Employee.where.not(deleted_at: nil).count }.by(1)
  end

  scenario "show all employees" do
    5.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }

    expected_table_md = <<~'EOF'
      | # | Name   | Department  | Actions                |
      | * | name-1 | development | Show \| Edit \| Delete |
      | * | name-2 | development | Show \| Edit \| Delete |  
      | * | name-3 | development | Show \| Edit \| Delete |
      | * | name-4 | development | Show \| Edit \| Delete |
      | * | name-5 | development | Show \| Edit \| Delete |
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
