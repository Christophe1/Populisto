class UsersController < FrontEndController

  before_filter :check_resource! #, :with_google_maps_api
  # before_filter :default_miles_range
  # before_filter :find_user
  # before_filter :load_data_for_checkbox
  # before_filter :fix_params, :only => :create

  def show
    param = params[:id] || params[:slug]
    @resource = User.unscoped.find_by_slug(param)
    @review = Review.new
    @reviews_count = @resource.reviews_count
    @users_in_area_count = (User.unscoped.with_entries.in_area(current_resource) - User.unscoped.find(current_resource.id).to_a).count
    @friends_outside = []
    if current_user
      User.unscoped.with_entries.beyond(20.01, :units => :km, :origin => current_resource).each do |usr|
        if usr.friend_of?(current_resource)
          @friends_outside << usr
        end
      end
    elsif current_company
      @users_outside = User.unscoped.with_entries.beyond(20.01, :units => :km, :origin => current_resource)
    end
  end

  def address_book
    param = params[:id] || params[:slug]
    @resource = User.unscoped.find_by_slug(param)
    @review = Review.new
    @reviews = @resource.reviews
  end

  def users_in_area
    users_in_area = User.unscoped.with_entries.in_area(current_resource)
    if current_user
      friends = current_resource.facebook_friends.in_range(0..20, :units => :km, :origin => current_resource)
      @app_friends = current_user.populisto_friends.in_range(0..20, :units => :km, :origin => current_resource)
      all_friends = []
      friends.each do |f|
        f.facebook_friends.in_range(0..20, :units => :km, :origin => current_user).each do |ff|
          all_friends << ff  if ff.reviews_count > 0
        end
        all_friends << f if f.reviews_count > 0
      end
      @all_friends = @app_friends + all_friends
      @friends = all_friends.uniq - current_resource.to_a
      @others = users_in_area -@all_friends # - @app_friends
    elsif current_company
      @app_friends = []
      @all_friends = []
      @friends = []
      @others = users_in_area - User.unscoped.find(current_resource.id).to_a # removing current logged in company from list
    end
  end

  def friends_outside_area
    @friends_outside = []
    @others_outside  = []
    @app_friends_outside = []
    @users = User.with_entries.beyond(20.01, :units => :km, :origin => current_resource)

    @users.each do |usr|
      if usr.friend_of?(current_resource)
        @friends_outside << usr
      elsif usr.populisto_friend?(current_resource)
        @app_friends_outside << usr
      else
        @others_outside << usr
      end
    end
  end

  def users_outside_area
    @users_outside = User.unscoped.with_entries.beyond(20.01, :units => :km, :origin => current_resource)
  end

  def follow
    @user = User.find_by_slug(params[:id])
    relation = FriendRelation.where(:provider => SocialNetwork::POPULISTO,
                      :source_user_id => current_resource.id, :target_user_id => @user.id)
    unless relation.present?
      current_resource.follow!(@user)
    end
  end

  def unfollow
    @user = User.find_by_slug(params[:id])
    relation = FriendRelation.where(:provider => SocialNetwork::POPULISTO,
      :source_user_id => current_resource.id, :target_user_id => @user.id).first
    relation.destroy
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
