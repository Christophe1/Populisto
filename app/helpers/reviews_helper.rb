module ReviewsHelper
# the 'edit' link for a review is only available to current_user when he is looking at his page in
# its entirety. If he does a search for 'plumber', and his entry comes up, he can't edit it
#from there. He has to go into his page.

#  show the 'edit' link, if the current_user is looking at his own page
  def review_block(review, options = {})
    options = {:review => review, :add_to_my_list => false}.merge(options)
    # options[:edit_enabled]  ||= review.user == current_user
    render 'reviews/review', options
  end

end
