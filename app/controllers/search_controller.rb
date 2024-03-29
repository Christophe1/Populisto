
#maybe all of this file can be deleted, because I've copied the methods
#into the application controller.rb. Hopefully it's redundant now, because I want
#it to be - search is to be done from the header.
 class SearchController < FrontEndController
   before_filter :check_resource!
   before_filter :with_google_maps_api
   before_filter :default_miles_range
   before_filter :load_data_for_checkbox
   before_filter :fix_params, :only => :create

  def index
    @review = Review.new
  end

  def create
    terms = params[:review][:search_ids]
    if terms.any?
      if current_user
        search_for_users(terms)
      elsif
        search_for_companies(terms)
      end
      # companies not used yet
      #@companies = Company.scoped_by_search_params(terms, current_resource) || []
      render :action => :index
    else
      redirect_to :back
    end
  end

  def search_for_users(terms)
    @review = Review.new params[:review]
    @fb_friends_reviews = []
    @other_people_reviews = []
    @fb_friends_reviews_outside = []
    @populisto_friends_reviews = []
    @populisto_friends_outside_reviews = []
    returned_reviews = Review.scoped_by_search_params(terms, current_resource)

    @user_reviews = returned_reviews[0]
    returned_reviews[1].each do |rev|
       @fb_friends_reviews << rev if rev.visible_to?(current_resource)
    end
    returned_reviews[2].each do |rev|
       @fb_friends_reviews_outside << rev if rev.visible_to?(current_resource)
    end
    returned_reviews[3].each do |rev|
      @other_people_reviews << rev if rev.visible_to?(current_resource)
    end
    returned_reviews[4].each do |rev|
      @populisto_friends_reviews << rev if rev.visible_to?(current_resource)
    end
    returned_reviews[5].each do |rev|
      @populisto_friends_outside_reviews << rev if rev.visible_to?(current_resource)
    end
    @all_reviews = @user_reviews + @fb_friends_reviews + @other_people_reviews +  @fb_friends_reviews_outside + @populisto_friends_reviews + @populisto_friends_outside_reviews
  end

  def search_for_companies(terms)
    @review = Review.new params[:review]
    @users_in_area = []
    @users_outside_area = []
    returned_reviews = Review.scoped_by_search_params_for_company(terms, current_resource)

    @user_reviews = returned_reviews[0]
    returned_reviews[1].each do |rev|
       @users_in_area << rev if rev.visible_to?(current_resource)
    end
    returned_reviews[2].each do |rev|
       @users_outside_area << rev if rev.visible_to?(current_resource)
    end
    @all_reviews = returned_reviews
  end

  def change_range
    current_range = (params[:current_range] || default_range).to_i
    cookies[:kms_range] = new_range(current_range)
    redirect_to :action => :index
  end

  protected

  def default_miles_range
    @kms_range = (cookies[:kms_range] || default_range).to_i
  end

  private

  def fix_params
    params[:review] ||= {}
    params[:review][:search_ids] ||= []
    params[:review][:search_ids].reject!(&:blank?)
  end

 #I added the method below to the users_controller,
 #updating for search box in the header,
 #so maybe it can be deleted
   # def load_data_for_checkbox
   #  categories = Category.fetch_all.map{|c| [c.name, "category_#{c.id}"] }
   #  users_in_my_area = User.within(default_range, :origin => current_user)
   #  followers = users_in_my_area.followers_for(current_user)
   #  following = users_in_my_area.following_by(current_user)
   #   other = users_in_my_area - followers - following - [current_user]

   #   [followers, following, other].each do |users|
   #     users.map!{ |u| [u.front_name.to_s + '|' + u.city.to_s, "user_#{u.id}"] }
   #   end

   #   @data = [[I18n.t('search.group.category'), categories],
   #            [I18n.t('search.group.following_in'), following],
   #            [I18n.t('search.group.followers_in'), followers],
   #            [I18n.t('search.group.other_people'), other]]
   # end
 #I added the method below to the users_controller,
 #updating for search box in the header,
 #so maybe it can be deleted
   def default_range
    20
   end

   def new_range(old_range)
     {20 => 10, 10 => 20}[old_range]
   end

 end

