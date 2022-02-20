class Participant < ApplicationRecord
  belongs_to :employee
  belongs_to :lunch

  def peers
    self.class.where(lunch: lunch, lunch_group: lunch_group).where.not(employee: employee).all
  end
end
