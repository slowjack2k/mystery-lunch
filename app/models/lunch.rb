class Lunch < ApplicationRecord
  has_many :participants, autosave: true

  scope :order_by_take_place, -> { order(year: :desc, month: :desc) }

  def self.current_lunch
    order_by_take_place.first
  end

  def self.for_show(id)
    Lunch.includes(participants: :employee).find(id)
  end

  def previous_lunch
    self.class.order_by_take_place.where("year < :current_year OR (year = :current_year AND month < :current_month)", {current_year: year, current_month: month}).first
  end

  def next_lunch
    self.class.order_by_take_place.where("year > :current_year OR (year = :current_year AND month > :current_month)", {current_year: year, current_month: month}).first
  end

  def add_to_different_lunch_group(participation)
    current_pairing = pairs

    current_pairing.delete participation.lunch_group

    to_be_added = nil

    predicate_order(participation.employee.department) do |predicate|
      (to_be_added, _) = current_pairing.find(&predicate)
      to_be_added.present?
    end

    participation.update_column(:lunch_group, to_be_added) if to_be_added
  end

  def create_new_participation_for(employee)
    to_be_added = nil
    current_pairing = pairs

    predicate_order(employee.department) do |predicate|
      (to_be_added, _) = current_pairing.find(&predicate)

      to_be_added.present?
    end

    if to_be_added.present?
      participants.create!(lunch_group: to_be_added,
        employee: employee)
    end
  end

  def title
    "#{month} / #{year}"
  end

  def pairs(filter_by_department = nil)
    participants.group_by { |participant| participant.lunch_group }
      .transform_values { |participants| participants.map(&:employee) }
      .delete_if do |_group_name, participants|
      filter_by_department.present? && participants.none? { |participant| participant.department == filter_by_department }
    end
  end

  private

  def predicate_order(disallowed_department, &block)
    all_different_department = proc { |participants| participants.all? { |employee| employee.department != disallowed_department } }
    two_part = proc { |participants| participants.size == 2 }

    two_members_different_departments = proc { |_lunch_group, participants| two_part.call(participants) && all_different_department.call(participants) }
    more_members_different_departments = proc { |_lunch_group, participants| all_different_department.call(participants) }
    two_members = proc { |_lunch_group, participants| two_part.call(participants) }
    any = proc { |_lunch_group, _participants| true }

    [two_members_different_departments, more_members_different_departments, two_members, any].find do |predicate|
      block.call predicate
    end
  end
end
