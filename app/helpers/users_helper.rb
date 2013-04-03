module UsersHelper
  def your_page(user)
    if user == current_user
      I18n.t('helpers.your_page')
    else
      user.first_name.capitalize + I18n.t('helpers.s_page')
    end
  end
  
  def your_location(user)
    if user == current_user
      "Your area: #{user.address}"
    else
      ""
    end
  end
end
