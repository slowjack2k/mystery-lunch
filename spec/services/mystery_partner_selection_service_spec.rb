require "rails_helper"

RSpec.describe MysteryPartnerSelectionService, type: :model do
  def create_departments
    cnt_employess = [4, 1, 3, 3, 4, 3, 1, 4, 4].shuffle

    Employee::DEPARTMENTS.each_with_index.each_with_object({}) { |(department, index), res| res[department] = create_list(:employee, cnt_employess[index], department: department) }
  end

  it "pairs all employees" do
    create_departments

    pairs = MysteryPartnerSelectionService.call year: 1, month: 1
    cnt_employees_paired = pairs.map { |pair| pair.map(&:id) }.flatten.uniq.count

    expect(cnt_employees_paired).to eq 27
  end

  it "does not pair employees of the same department" do
    create_departments

    pairs = MysteryPartnerSelectionService.call year: 1, month: 1
    all_departments_uniq = pairs.map { |pair| pair.map(&:department) }.all? { |pair_departments| pair_departments.size == pair_departments.uniq.size }

    expect(all_departments_uniq).to be_truthy
  end

  it "creates a pairing with 3 employees, when the employee cnt is odd" do
    create_departments

    pairs = MysteryPartnerSelectionService.call year: 1, month: 1
    count_pairs_with_more_than_two_members = pairs.count { |pair| pair.size > 2 }

    expect(count_pairs_with_more_than_two_members).to eq 1
  end

  it "creates a only pairings with 2 employees, when the employee cnt is even" do
    create_departments

    Employee.first.destroy!

    pairs = MysteryPartnerSelectionService.call year: 1, month: 1
    count_pairs_without_two_members = pairs.count { |pair| pair.size != 2 }

    expect(count_pairs_without_two_members).to eq 0
  end

  it "works with departments larger than 50% of all employees" do
    create_list(:employee, 3, department: "operations")
    create_list(:employee, 2, department: "sales")

    pairs = MysteryPartnerSelectionService.call year: 1, month: 1
    cnt_employees_paired = pairs.map { |pair| pair.map(&:id) }.flatten.uniq.count

    expect(cnt_employees_paired).to eq 5
  end

  it "previous pairings don't get paired again" do
    last_pairings = {}
    create_departments

    3.times do |month|
      pairs = MysteryPartnerSelectionService.call year: 1, month: month
      pairs.each do |pair|
        ids = pair.map(&:id)

        ids.each do |id|
          last_pairings[id] ||= []
          last_pairings[id].push(*(ids - [id]))
        end
      end
    end

    pairs = MysteryPartnerSelectionService.call year: 2, month: 1

    old_pairing_exists = pairs.any? { |pair| pair.any? { |employee| employee.id.in? last_pairings.fetch(employee.id, []) } }

    expect(old_pairing_exists).to be_falsey
  end
end
