module UsersHelper
  def link_to_follow_toggle(user)
    if current_user.populisto_friend?(user)
      link_to 'Unfollow this Address Book', unfollow_user_path(user), :remote => true unless current_resource.friend_of?(user)
    else
      link_to 'Follow this Address Book', follow_user_path(user), :remote => true unless current_resource.friend_of?(user)
    end
  end

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
end
