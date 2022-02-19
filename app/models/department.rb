class Department
  def initialize(employees:)
    @employees = employees
  end

  def next_random_employee(previous_partners, employees_without_partners)
    return unless has_next_employee?(previous_partners)

    employees.shuffle!
    employees.delete(next_employee(employees_without_partners, previous_partners))
  end

  def has_next_employee?(previous_partners)
    (employees - previous_partners).size > 0
  end

  def is_critical?(employees_without_partners)
    other_pairing_partners = employees_without_partners - employees
    max_pairing_members = employees.map { |employee| employee.previous_partners.size }.max
    left_employess_cnt_gets_near_half(max_pairing_members, other_pairing_partners) ||
      low_on_possible_partners_for_an_employee(other_pairing_partners)
  end

  def blank?
    employees.blank?
  end

  def size
    employees.size
  end

  def split_at(n)
    splitted_employees = employees.drop(n)
    self.employees = employees - splitted_employees
    Department.new employees: splitted_employees
  end

  attr_accessor :employees

  private

  def low_on_possible_partners_for_an_employee(other_pairing_partners)
    employees.any? { |employee| (other_pairing_partners - employee.previous_partners).size < 3 }
  end

  def left_employess_cnt_gets_near_half(max_pairing_members, other_pairing_partners)
    size + max_pairing_members + 1 > other_pairing_partners.size
  end

  def next_employee(employees_without_partners, previous_partners)
    possible_partners = (employees - previous_partners)
    possible_partners.find { |employee| (employees_without_partners - employee.previous_partners).size < 2 } || possible_partners.first
  end
end
