class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_action :logged_in_user?, only: [:admin], if: -> { User.any? }
  before_action :is_admin?, only: [:admin], if: -> { User.any? }
  before_action :homepage_sql_caching, only: [:home]
  before_action :setup

  def home
  end

  def single_page
  end

  def starters_website
  end

  def website_op_maat
  end

  def webapplicatie
  end

  def admin
    render "admin"
  end

  def website_analyse
  end

  def setup
    @contact = Contactform.new
  end
end
