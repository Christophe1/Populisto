module ReviewsHelper

	#I think this file does nothing, so probably can be deleted.
	#although I think it is causing trouble with the 'edit' link, 
	#when creating a review, so I'm just leaving it in. Mysterious!

  def review_block(review, options = {})
    options = {:review => review, :add_to_my_list => false}.merge(options)
    #  show the 'edit' link, if the current_user is looking at his own page
     options[:edit_enabled]  ||= review.user == current_user
    render 'reviews/review', options
  end

end






