class DestroyEmployeeService < ApplicationService
  def initialize(employee:)
    @employee = employee
  end

  def call
    instrument "delete_employees" do
      Employee.transaction do
        employee.soft_destroy.tap do
          redistribute_peers

          employee.current_participation&.destroy
        end
      end
    end
  end

  private

  def redistribute_peers
    return unless employee.current_participation

    peers = employee.current_participation.peers
    if peers.size == 1
      participant = peers.first
      Lunch.current_lunch.add_to_different_lunch_group(participant)
      participant.reload

      participants = [participant] + participant.peers

      email_participants participants
    end
  end

  def email_participants(participations)
    ParticipationEmailService.call participations: participations
  end

  attr_reader :employee
end
