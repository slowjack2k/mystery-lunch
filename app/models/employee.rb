class Employee < ApplicationRecord
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development data]

  validates_inclusion_of :department, in: DEPARTMENTS


  attr_accessor :photo
end
