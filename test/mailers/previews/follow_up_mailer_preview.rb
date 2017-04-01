# Preview all emails at http://localhost:3000/rails/mailers/follow_up_mailer
class FollowUpMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/follow_up_mailer/reminder_email
  def reminder_email
    FollowUpMailer.reminder_email
  end

end
