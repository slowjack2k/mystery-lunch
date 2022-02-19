require "rails_helper"
RSpec.describe Departments do
  def create_departments(cnt_employees = [4, 1, 3, 3, 4, 3, 1, 4, 4])
    cnt_employees = cnt_employees.shuffle

    Employee::DEPARTMENTS.each_with_index.each_with_object({}) do |(department, index), res|
      employees = create_list(:employee, cnt_employees[index], department: department)
      res[department] = Department.new employees: employees
    end
  end

  it "pairs all employees" do
    departments = Departments.new departments: create_departments

    pairs = departments.pairings
    cnt_employees_paired = pairs.map { |pair| pair.map(&:id) }.flatten.uniq.count

    expect(cnt_employees_paired).to eq 27
  end

  it "does not pair employees of the same department" do
    departments = Departments.new departments: create_departments

    pairs = departments.pairings
    all_departments_uniq = pairs.map { |pair| pair.map(&:department) }.all? { |pair_departments| pair_departments.size == pair_departments.uniq.size }

    expect(all_departments_uniq).to be_truthy
  end

  it "creates a pairing with 3 employees, when the employee cnt is odd" do
    departments = Departments.new departments: create_departments

    pairs = departments.pairings
    count_pairs_with_more_than_two_members = pairs.count { |pair| pair.size > 2 }

    expect(count_pairs_with_more_than_two_members).to eq 1
  end

  it "creates only pairings with 2 employees, when the employee cnt is even" do
    data = create_departments [4, 2, 3, 3, 4, 3, 1, 4, 4]
    departments = Departments.new departments: data

    pairs = departments.pairings
    count_pairs_without_two_members = pairs.count { |pair| pair.size != 2 }

    expect(count_pairs_without_two_members).to eq 0
  end

  it "works with departments larger than 50% of all employees" do
    data = create_departments [9, 1, 1, 1, 1, 1, 1, 1, 1]
    departments = Departments.new departments: data

    pairs = departments.pairings
    cnt_employees_paired = pairs.map { |pair| pair.map(&:id) }.flatten.uniq.count

    expect(cnt_employees_paired).to eq 17
  end

  it "returns the number of all employees" do
    departments = Departments.new departments: create_departments

    expect(departments.cnt_employees).to eq 27
  end
end
