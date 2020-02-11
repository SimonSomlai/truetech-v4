module ApplicationHelper
  def days_ago(arg)
    time = arg.days.ago.strftime("%A - %d/%m")
  end

  def months_ago(arg)
    time = arg.months.ago.strftime("%B")
  end

  def is_video(item)
    url = item.images_url
    !!url.match(/.mp4/)
  end

  def comment
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
    Visit.where(date: time_range(unit, timeunit))
  end

  def category(project)
    if I18n.locale == :en
      case project.service
      when "starters website" then "Starter Website"
      when "website op maat" then "Custom Website"
      when "webapplicatie" then"Web Application"
      else
        "Single Page"
      end
    else
      project.service.capitalize
    end
  end
end
