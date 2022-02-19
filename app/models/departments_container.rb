class DepartmentsContainer
  class IllegalCombinationError < StandardError; end

  def initialize(departments:)
    @departments = departments
    @department_names = departments.keys
  end

  def pairings
    shuffle_employees.each_slice(2).to_a.tap do |pairs|
      if pairs.last.size == 1 && pairs.size > 1
        employee_without_partner = pairs.pop.first
        to_be_added = pairs.find { |pair| !pair.map { |employee| employee.department }.include?(employee_without_partner.department) }
        to_be_added ||= pairs.first
        to_be_added.push employee_without_partner
      end
    end
  end

  private

  def shuffle_employees
    split_large_department

    result = []

    while cnt_employees_without_partners > 0
      prepare_departments
      previous_employee = result.size.even? ? Employee.new : result.last
      pick_next_department(previous_employee.department, previous_employee.previous_partners)
      pick_next_employee(previous_employee, result)
    end

    result
  end

  def split_large_department
    limit = cnt_employees_without_partners / 2
    department_with_more_then_50_percent = departments.values.find { |department| department.size >= limit }

    if department_with_more_then_50_percent
      left_over_employees = department_with_more_then_50_percent.split_at(limit)
      new_department_name = "left-overs"
      department_names.push new_department_name
      departments[new_department_name] = left_over_employees
    end
  end

  def pick_next_employee(previous_employee, result)
    departments[@next_department].next_random_employee(previous_employee.previous_partners, employees_without_partners).tap do |current_employee|
      raise IllegalCombinationError if current_employee.blank?

      result.push current_employee
    end
  end

  def pick_next_department(illegal_department, previous_partners)
    available_departments = department_names.excluding(illegal_department)
    @next_department = available_departments.find { |dep| departments[dep].is_critical?(employees_without_partners) && departments[dep].has_next_employee?(previous_partners) }
    @next_department ||= available_departments.find { |dep| departments[dep].has_next_employee?(previous_partners) }
    @next_department ||= department_names.first
  end

  def prepare_departments
    department_names.delete_if { |department| departments[department].blank? }
    department_names.shuffle!
  end

  def cnt_employees_without_partners
    employees_without_partners.size
  end

  def employees_without_partners
    department_names.map { |department| departments[department].employees }.flatten
  end

  attr_reader :departments, :department_names
end
