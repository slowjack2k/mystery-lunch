class Participant < ApplicationRecord
  belongs_to :employee
  belongs_to :lunch
end
