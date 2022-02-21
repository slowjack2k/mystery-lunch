class ParticipationMailer < ApplicationMailer
  default from: Rails.configuration.no_reply_from_email

  def email
    @receiver_name = params.fetch(:receiver_name)
    @other_participants = params.fetch(:other_participants)

    mail(
      to: params.fetch(:receiver_email),
      subject: "Your lunch #{params.fetch(:lunch_title)}"
    )
  end
end
