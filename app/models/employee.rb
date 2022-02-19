class Employee < ApplicationRecord
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development data].freeze

  has_many :participations, -> { joins(:lunch).order(year: :desc, month: :desc).limit(3) }, class_name: "Participant", foreign_key: :employee_id

  validates_inclusion_of :department, in: DEPARTMENTS

  attr_accessor :photo

  define_model_callbacks :soft_destroy

  def soft_destroy
    return unless deleted_at.blank?

    run_callbacks :soft_destroy do
      update_column("deleted_at", Time.zone.now)
    end
  end

  def deleted?
    deleted_at.present?
  end

  def previous_partners
    @previous_partners ||= participations.map do |participantion|
      Participant.includes(:employee).where(lunch_group: participantion.lunch_group, lunch: participantion.lunch).where.not(employee: self).map(&:employee)
    end.flatten
  end
end
