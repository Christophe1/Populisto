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

  def pop_something(user)
    if user == current_user
      I18n.t('helpers.pop_something_in')
    else
      ""
    end
  end

  def pop_something2(user)
    if user == current_user
      I18n.t('helpers.pop_something_in2')
    else
      ""
    end
  end

  def resource_full_name(name)
    new_name = name + "'"
    if name.end_with?('s')
      return new_name + " Address Book:"
    else
      return new_name + "s Address Book:"
    end
  end

  def fb_friends_relation(user, current_user)
    if user.friend_of?(current_user)
      return 'Fb friend'
    else
      friends = (current_user.facebook_friends & user.facebook_friends).join(', ')
      "Fb friend of: #{friends}" if friends.any?
    end
  end
end
