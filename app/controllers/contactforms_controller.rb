class ContactformsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :firstname

  def create  # Sends an email based on the form on the page
    page = request.referrer.split("/")[-1] # Passes in the current page based on absolute url
    # /nl & /en = home page & also when it doesn't contain /en || /nl
    page = "home" if page.size <= 2 || !((request.referrer.split("/") & ["nl","en"]).present?)
    params[:contactform].merge!(page: page)
    @contact = Contactform.new(params[:contactform])
    @contact.request = request
    if @contact.deliver
      respond_to do |format|
        format.html { redirect_to request.referrer }
        format.js
      end
    else
      flash.now[:error] = "Cannot send message"
      redirect_to request.referrer
    end
  end
end
