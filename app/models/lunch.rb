class Lunch < ApplicationRecord
  has_many :participants, autosave: true

  scope :order_by_take_place, -> { order(year: :desc, month: :desc) }

  def self.current_lunch
    order_by_take_place.first
  end

  def previous_lunch
    self.class.order_by_take_place.where("year < :current_year OR (year = :current_year AND month < :current_month)", {current_year: year, current_month: month}).first
  end

  def next_lunch
    self.class.order_by_take_place.where("year > :current_year OR (year = :current_year AND month > :current_month)", {current_year: year, current_month: month}).first
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
end
