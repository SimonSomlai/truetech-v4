class Contactform < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject

  attribute :referrer
  attribute :website
  attribute :message
  attribute :phone

  attribute :page, :validate => true
  # Including attachments
  attribute :file, :attachment => true
  # Checking for bots
  attribute :botcheck, :captcha => true

  def headers
    {
      :subject => "TrueTech Contact Form",
      :to => "info@truetech.be",
      :from => %("#{name}" <#{email}>)
    }
  end
end
