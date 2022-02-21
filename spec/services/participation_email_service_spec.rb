require "rails_helper"

RSpec.describe ParticipationEmailService do
  it "sends an email to all Participants" do
    create :lunch, :with_participants

    current_employee = Employee.all.sample

    expect do
      ParticipationEmailService.call participations: [current_employee.current_participation]
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
