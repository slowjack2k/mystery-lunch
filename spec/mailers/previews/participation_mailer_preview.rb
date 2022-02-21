# Preview all emails at http://localhost:3000/rails/mailers/participation_mailer
class ParticipationMailerPreview < ActionMailer::Preview
  def email
    participant = Participant.all.sample

    ParticipationMailer.with(receiver_email: participant.employee.email,
      receiver_name: participant.employee.name,
      lunch_title: participant.lunch.title,
      other_participants: participant.peers.map(&:employee).map(&:name)).email
  end
end
