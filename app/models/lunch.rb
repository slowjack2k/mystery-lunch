class Lunch < ApplicationRecord
  has_many :participants, autosave: true

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
