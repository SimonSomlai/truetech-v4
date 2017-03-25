class ContactformsController < ApplicationController
  def create
    page = request.referrer.split("/")[-1]
    page = "home" if page.size == 2
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
