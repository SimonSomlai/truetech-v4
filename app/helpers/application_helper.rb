# frozen_string_literal: true

module ApplicationHelper
  def days_ago(arg)
    time = arg.days.ago.strftime('%A - %d/%m')
  end

  def months_ago(arg)
    time = arg.months.ago.strftime('%B')
  end

  def is_video(item)
    return false if !item

    return !!item.content_type.match(/video|mp4|mov/)
  end

  def comment; end

  def production_only
    Rails.env.production?
  end

  def show_svg(path)
    File.open("app/assets/images/#{path}", 'rb') do |file|
      raw file.read
    end
  end

  def is_logged_in?
    !session[:user_id].nil?
  end


  def category(project)
    if I18n.locale == :en
      case project.service
      when 'starters website' then 'Starter Website'
      when 'website op maat' then 'Custom Website'
      when 'webapplicatie' then'Web Application'
      else
        'Single Page'
      end
    else
      project.service.capitalize
    end
  end

  def url(attachment)
    return "" if !attachment 

    if attachment.respond_to?(:key)
      ActiveStorage::Current.host = request.base_url
      ActiveStorage::Blob.service.url(attachment.key, disposition: 'inline', content_type: attachment.content_type, filename: attachment.filename, expires_in: 200_000)
    else
      ""
    end
  end
end
