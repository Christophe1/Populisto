class StaticPagesController < ApplicationController
skip_before_filter :authenticate_user!, :only => :terms_and_conditions

  def about_us
    # current_user.lat= @user.lat
    # current_user.lng= @user.lng
  end

  def contact_us
  end

  def faq
    # @user = User.find(params[:id])
  end

  def competition_terms
  end

  def terms_and_conditions
  end

  end
