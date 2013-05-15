class StaticPagesController < ApplicationController
	# skip_before_filter :authenticate_user!, only: :terms_and_conditions
skip_before_filter :authenticate_user!, :only => :terms_and_conditions

  def about_us
  end

  def contact_us
  end

  def faq
  end

  def competition_terms
  end

  def terms_and_conditions
  end

  end
