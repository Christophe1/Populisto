module ReviewsHelper

	#I think this file does nothing, so probably can be deleted.
	#although I think it is causing trouble with the 'edit' link,
	#when creating a review, so I'm just leaving it in. Mysterious!

	#Update: I think it's actually important for some of the js.erb files.

  def review_block(review, options = {})
    options = {:review => review, :add_to_my_list => false}.merge(options)
    #  show the 'edit' link, if the current_user is looking at his own page
     options[:edit_enabled]  ||= review.user == current_user
    render 'reviews/review', options
  end

  def sorted_categories
    categories = []
    first_in_list = Category.find_by_name("Personal Contact")
    # categories << first_in_list

    Category.all.each do |cat|
      categories << cat
    end

    return categories.unshift(categories.delete_at(categories.index(first_in_list)))
  end

end
