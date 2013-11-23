class UsersController < FrontEndController

  before_filter :check_resource! #, :with_google_maps_api
  # before_filter :default_miles_range
  # before_filter :find_user
  # before_filter :load_data_for_checkbox
  # before_filter :fix_params, :only => :create


  def show
    param = params[:id] || params[:slug]
    @resource = User.unscoped.find_by_slug(param)
    if @resource == current_resource
      @review = Review.new
      @reviews_count = @resource.reviews_count
      @users_in_area_count = User.in_area(current_resource).count
      @friends = facebook_friends_outside_area
    else
      redirect_to address_book_path(@resource)
    end
  end

  def address_book
    param = params[:id] || params[:slug]
    @resource = User.unscoped.find_by_slug(param)
    @review = Review.new
    @reviews = @resource.reviews
  end

  def users_in_area
    @friends = []
    @others = []
    users = (current_resource.facebook_friends + current_resource.facebook_neighbors).uniq
    users.each do |user|
      if current_resource.distance_to(user) < 20
        @friends << user
      end
    end

    others = User.within(20, :units => :km, :origin => [current_resource.lat, current_resource.lng])
    @others = others - @friends - current_resource.to_a
  end

  def friends_outside_area
    @friends = facebook_friends_outside_area
  end

  def facebook_friends_outside_area
    friends_outside_area = []
    current_resource.facebook_friends.each do |u|
      if u.distance_to(current_resource) > 20
        friends_outside_area << u
      end
    end
    friends_outside_area
  end

  def address_toggle
    @user.update_attributes(:address_visible => params[:value]) if @user == current_user
  end

  def following_followers
    @following = User.following_by @user
    @followers = User.followers_for @user
    render :layout => false
  end

  def coming

  end

  # protected
  #   def find_user
  #     @user = User.find(params[:id])
  #   end


  # def create
  #   @review = Review.new params[:review]
  #   @reviews = Review.scoped_by_search_params(params, current_user)
  #   render :action => :index
  # end

#   def change_range
#     current_range = (params[:current_range] || default_range).to_i
#     cookies[:kms_range] = new_range(current_range)
#     redirect_to :action => :index
#   end

# protected

#   def default_miles_range
#     @kms_range = (cookies[:kms_range] || default_range).to_i
#   end

#   private

#   def fix_params
#     params[:review] ||= {}
#     params[:review][:search_ids] ||= []
#     params[:review][:search_ids].reject!(&:blank?)
#   end


# def load_data_for_checkbox
#     categories = Category.fetch_all.map{|c| [c.name, "category_#{c.id}"] }
#     users_in_my_area = User.within(default_range, :origin => current_user)
#     followers = users_in_my_area.followers_for(current_user)
#     following = users_in_my_area.following_by(current_user)
#     other = users_in_my_area - followers - following - [current_user]

#     [followers, following, other].each do |users|
#       users.map!{ |u| [u.front_name.to_s + '|' + u.city.to_s, "user_#{u.id}"] }
#     end

#     @data = [[I18n.t('search.group.category'), categories],
#              [I18n.t('search.group.followers_in'), followers],
#              [I18n.t('search.group.following_in'), following],
#              [I18n.t('search.group.other_people'), other]]
#   end

#     def default_range
#     20
#   end

#     def new_range(old_range)
#     {20 => 10, 10 => 20}[old_range]
#   end

end
