require "time"

desc "Sends follow up emails for projects"
task :follow_up => :environment do
  binding.pry
  @projects = Project.where(follow_up: true)
  @projects.each do |project|
    case
      when (Time.now.to_date - 7.days === project.created_at.to_date) then FollowUpMailer.reminder_email(project.title, "1 week").deliver! 
      when (Time.now.to_date - 22.days === project.created_at.to_date) then FollowUpMailer.reminder_email(project.title, "3 weeks").deliver! 
      when (Time.now.to_date - 50.days === project.created_at.to_date) then FollowUpMailer.reminder_email(project.title, "1 month").deliver! 
      when (Time.now.to_date - 130.days === project.created_at.to_date) then FollowUpMailer.reminder_email(project.title, "3 months").deliver! 
      when (Time.now.to_date - 310.days === project.created_at.to_date) then FollowUpMailer.reminder_email(project.title, "6 months").deliver! 
    end
  end
end
