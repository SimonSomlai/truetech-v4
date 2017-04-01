class FollowUpMailer < ApplicationMailer
  default from: "noreply@truetech.be"

  def reminder_email(title, time)
    @title, @time = title, time
    mail(to: "info@truetech.be", subject: "Follow-Up Reminder #{@title}")
  end
end
