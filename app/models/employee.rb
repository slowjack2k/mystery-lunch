class Employee < ApplicationRecord
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development data].freeze

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
    @previous_partners ||= []
  end

  def add_partners(*new_partner)
    previous_partners.push(*new_partner)
  end
end
