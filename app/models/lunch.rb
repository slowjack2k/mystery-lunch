class Lunch < ApplicationRecord
  has_many :participants, autosave: true

  def title
    "#{month} / #{year}"
  end

  def pairs
    participants.group_by { |participant| participant.lunch_group }.transform_values { |participants| participants.map(&:employee) }
  end
end
