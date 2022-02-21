class Participant < ApplicationRecord
  belongs_to :employee
  belongs_to :lunch

  def other_participiants_in_group
    self.class.includes(:employee).where(lunch_group: lunch_group, lunch: lunch).where.not(employee: employee)
  end

  def peers
    self.class.where(lunch: lunch, lunch_group: lunch_group).where.not(employee: employee).all
  end
end
