require "rails_helper"

RSpec.describe ParticipationMailer, type: :mailer do
  it "sends an email" do
    expect do
      ParticipationMailer.with(receiver_email: "test@example.com",
        receiver_name: "max muster",
        lunch_title: "some title",
        other_participants: []).email.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
