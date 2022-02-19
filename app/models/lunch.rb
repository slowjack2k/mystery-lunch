class Lunch < ApplicationRecord
  has_many :participants, autosave: true
end
