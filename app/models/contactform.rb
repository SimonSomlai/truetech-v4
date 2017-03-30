class Contactform < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject

  attribute :referrer
  attribute :website
  attribute :message
  attribute :phone

  attribute :page, :validate => true
  attribute :file, :attachment => true   # Including attachments
  attribute :botcheck, :captcha => true   # if captcha is filled in, it's a bot

  def headers
    {
      :subject => "TrueTech Contact Form",
      :to => "info@truetech.be",
      :from => %("#{name}" <#{email}>)
    }
  end
end
