class Contactform < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject

  attribute :message
  attribute :phone
  # Including attachments
  attribute :file, :attachment => true
  # Checking for bots
  attribute :botcheck, :captcha => true

  def headers
    {
      :subject => "TrueTech Contact Form",
      :to => "simon_somlai@hotmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end
