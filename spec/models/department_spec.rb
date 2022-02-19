require "rails_helper"
RSpec.describe Department do
  def build_employees(cnt = 5)
    build_list(:employee, cnt)
  end

  it "provides a random employee" do
    employees = build_employees
    randomize_employees = employees.shuffle

    department = Department.new employees: employees, shuffle_strategy: ->(_) { randomize_employees.dup }
    next_employee = department.next_random_employee([], employees)

    expect(next_employee).to eq randomize_employees.first
  end

  it "removes the choosen employee from the available employees" do
    department = Department.new employees: build_employees

    expect do
      department.next_random_employee([], build_employees)
    end.to change { department.size }.by(-1)
  end

  it "returns 'true' when a next employee exists" do
    department = Department.new employees: build_employees

    expect(department.has_next_employee?(build_employees)).to be_truthy
  end

  it "returns 'false' when a none employee" do
    department = Department.new employees: []

    expect(department.has_next_employee?(build_employees)).to be_falsey
  end

  it "returns 'false' when all employees have been partnered before" do
    previous_partners = build_employees
    department = Department.new employees: previous_partners

    expect(department.has_next_employee?(previous_partners)).to be_falsey
  end

  it "creates a new department with the remaining elements, after the split" do
    department = Department.new employees: build_employees
    new_department = department.split_at(3)

    expect(new_department.size).to eq 2
  end

  it "after a split the old department contains n elements" do
    department = Department.new employees: build_employees
    department.split_at(3)

    expect(department.size).to eq 3
  end

  it "returns 'false' when enough potential partners are present" do
    employees_in_department = build_employees
    remaining_employees = employees_in_department + build_employees + build_employees
    department = Department.new employees: employees_in_department

    expect(department.is_critical?(remaining_employees)).to be_falsey
  end

  it "returns 'true' when potential partners are equal department size" do
    employees_in_department = build_employees
    remaining_employees = employees_in_department + build_employees

    department = Department.new employees: employees_in_department

    expect(department.is_critical?(remaining_employees)).to be_truthy
  end

  it "returns 'true' when a single employee in this department is low on potential partners" do
    employees_in_department = build_employees(3)
    previous_partners = build_employees(10)
    remaining_employees = employees_in_department + previous_partners + build_employees(3)

    allow(employees_in_department.first).to receive(:previous_partners).and_return(previous_partners)

    department = Department.new employees: employees_in_department

    expect(department.is_critical?(remaining_employees)).to be_truthy
  end
end
