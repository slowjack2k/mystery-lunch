class Employee
  DEPARTMENTS = %w[operations sales marketing risk management finance HR development data]
  include ActiveModel::API

  attr_accessor :name, :photo, :department, :id

  def persisted?
    id.present?
  end
end
