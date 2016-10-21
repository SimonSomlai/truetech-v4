class ContactformsController < ApplicationController
  def create
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
