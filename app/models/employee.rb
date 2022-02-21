class Employee < ApplicationRecord
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development data].freeze

  has_many :participations, -> { joins(:lunch).order(year: :desc, month: :desc).limit(3) }, class_name: "Participant", foreign_key: :employee_id do
    def current_lunch
      where(lunch: Lunch.current_lunch)
    end
  end
  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates_inclusion_of :department, in: DEPARTMENTS

  define_model_callbacks :soft_destroy

  def self.valid_department?(department)
    department.in? DEPARTMENTS
  end

  def self.employees_by_department
    res = Employee::DEPARTMENTS.each_with_object({}) { |department, res| res[department] = [] }

    Employee.includes(:participations).where(deleted_at: nil).all.each_with_object(res) do |employee, res|
      res[employee.department].push employee
    end.each_with_object({}) do |(department, employees), result_hash|
      result_hash[department] = Department.new employees: employees
    end
  end

  def self.existing(id)
    Employee.where(deleted_at: nil).find(id)
  end

  def soft_destroy
    return unless deleted_at.blank?

    run_callbacks :soft_destroy do
      update_column("deleted_at", Time.zone.now)
    end
  end

  def deleted?
    deleted_at.present?
  end

  def current_participation
    participations.current_lunch.first
  end

  def previous_partners
    @previous_partners ||= participations.map do |participantion|
      Participant.includes(:employee).where(lunch_group: participantion.lunch_group, lunch: participantion.lunch).where.not(employee: self).map(&:employee)
    end.flatten
  end
end
