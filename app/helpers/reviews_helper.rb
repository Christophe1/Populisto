module ReviewsHelper

	#I think this file does nothing, so probably can be deleted.
	#although I think it is causing trouble with the 'edit' link,
	#when creating a review, so I'm just leaving it in. Mysterious!

	#Update: I think it's actually important for some of the js.erb files.

  def fb_friendship_relation(review, current_resource)
    owner = review.owner
    if current_resource.class.name == "User"
      if current_resource.friend_of?(review.owner)
         return "Fb friend"
       else
          friends = (current_resource.facebook_friends & owner.facebook_friends).join(', ')
         "Fb friend of: #{friends}" if friends.any?
      end
    end
  end

  def review_block(review, options = {})
    options = {:review => review, :add_to_my_list => false}.merge(options)
    #  show the 'edit' link, if the current_user is looking at his own page
     options[:edit_enabled]  ||= review.user == current_user
    render 'reviews/review', options
  end

  def sorted_categories
    categories = []
    first_in_list = Category.find(1)
    # categories << first_in_list

    Category.all.each do |cat|
      categories << cat
    end

    return categories.unshift(categories.delete_at(categories.index(first_in_list)))
  end

  def chosen_select_for_category(f)
    cats = []
    Category.filtered.order(:name).map{|c| cats << c}
    first_cat = Category.unscoped.find(1)
    cats.unshift(first_cat)
    f.input :category_ids, :collection => cats, :as => :chosen, :prompt => false,
            :input_html => { :multiple => true },
            :label => I18n.t('write_review.categories_selector_label'),
            :label_html => { :class => 'edit_form_titles' },
            :error_html => { :class => 'cant_be_blank'}
  end
end
