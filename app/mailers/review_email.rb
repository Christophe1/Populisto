class ReviewEmail < ActionMailer::Base
  layout "mailer"

  default :from => "noreply@populisto.com"

  def suggest_category(user, categories)
    @user = user
    @categories = categories
    mail(:to => 'harris.christophe@gmail.com', :subject => "Categories Suggestions from #{user.front_name}")
  end

end
