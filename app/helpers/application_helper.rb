module ApplicationHelper
  def days_ago(arg)
    time = arg.days.ago.strftime("%A - %d/%m")
  end

  def months_ago(arg)
    time = arg.months.ago.strftime("%B")
  end

  # Gets time range for x number time ago
  def time_range(unit, timeunit = nil)
    if timeunit == "weeks"
      now = Time.zone.now.beginning_of_week
    elsif timeunit == "months"
      now = Time.zone.now.beginning_of_month
    else
      now = Time.zone.now.beginning_of_day
    end
    # Ex: time_range(0, "days") --> Get the time range for today  between the beginning of today and the beginning of tommorow - 1 second
    now - unit.send(timeunit)..now + 1.send(timeunit) - 1.seconds - unit.send(timeunit)
  end

  def visits(unit, timeunit)
    Visit.where(started_at: time_range(unit, timeunit), user_id: nil).count
  end

  def views(unit, timeunit)
    Ahoy::Event.where(time: time_range(unit, timeunit), user_id: nil).count
  end

  def its_simon?
    current_visit != nil && current_visit.user_id == 1 ? true : false
  end

  def category(project)
    if I18n.locale == :en
      if project.service == "starters website"
        "Starter Website"
      elsif project.service == "website op maat"
        "Custom Website"
      elsif project.service == "webapplicatie"
        "Web Application"
      else
        "Single Page"
      end
    else
      return project.service
    end
  end
end
