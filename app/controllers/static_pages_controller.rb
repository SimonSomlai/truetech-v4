class StaticPagesController < ApplicationController
  include StaticPagesHelper
  before_filter :logged_in_user?, only: [:admin], if: "User.any?"
  before_filter :is_admin?, only: [:admin], if: "User.any?"
  before_action :homepage_sql_caching, only: [:home]
  before_action :setup

  def home
    ahoy.track "Homepage views", title: "Homepage" unless its_simon?
  end

  def single_page
    ahoy.track "Service views", title: "Single Page" unless its_simon?
  end

  def starters_website
    ahoy.track "Service views", title: "Starters Website" unless its_simon?
  end

  def website_op_maat
    ahoy.track "Service views", title: "Website Op Maat" unless its_simon?
  end

  def webapplicatie
    ahoy.track "Service views", title: "Webapplicatie" unless its_simon?
  end

  def admin
    get_referrals
    get_pageviews
  end

  def website_analyse
    ahoy.track "Promo Views", title: "Website Analyse" unless its_simon?
  end

  def setup
    @contact = Contactform.new
  end
end
