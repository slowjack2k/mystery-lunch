class ParticipationEmailService < ApplicationService
  def initialize(participations:)
    @participations = participations
  end

  def call
    instrument "send_participation_email" do
      participations.each do |participant|
        ParticipationMailer.with(receiver_email: participant.employee.email,
          receiver_name: participant.employee.name,
          lunch_title: participant.lunch.title,
          other_participants: participant.peers.map(&:employee).map(&:name)).email.deliver_now
      end
    end
  end

  private

  attr_reader :participations
end
