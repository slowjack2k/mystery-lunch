require "rails_helper"

RSpec.describe MysteryPartnerSelectionService do
  def create_departments
    cnt_employees = [4, 1, 3, 3, 4, 3, 1, 4, 4].shuffle

    Employee::DEPARTMENTS.each_with_index.each_with_object({}) { |(department, index), res| res[department] = create_list(:employee, cnt_employees[index], department: department) }
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

  it "creates a lunch" do
    create_departments

    expect do
      MysteryPartnerSelectionService.call year: 1, month: 1
    end.to change { Lunch.count }.by 1
  end

  it "stores all Participants" do
    create_departments

    expect do
      MysteryPartnerSelectionService.call year: 1, month: 1
    end.to change { Participant.count }.by 27
  end

  it "ignores soft deleted employees" do
    create_departments

    Employee.first.soft_destroy

    expect do
      MysteryPartnerSelectionService.call year: 1, month: 1
    end.to change { Participant.count }.by 26
  end
end
