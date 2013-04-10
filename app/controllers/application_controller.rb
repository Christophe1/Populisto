class ApplicationController < ActionController::Base

  protect_from_forgery


  before_filter :with_google_maps_api
  before_filter :default_miles_range
  before_filter :load_data_for_checkbox
  before_filter :fix_params, :only => :create

  before_filter :init_review

  layout :layout_by_resource

    def init_review
    @review = Review.new
  end

    def show    
    @review = Review.new
    @reviews = @user.reviews
  end

    def find_user
      @user = User.find(params[:id])
    end


  def create
    @review = Review.new params[:review]
    @reviews = Review.scoped_by_search_params(params, current_user)
    render :action => :index
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

  def fix_params
    params[:review] ||= {}
    params[:review][:search_ids] ||= []
    params[:review][:search_ids].reject!(&:blank?)
  end


  def load_data_for_checkbox
    categories = Category.fetch_all.map{|c| [c.name, "category_#{c.id}"] }    
    users_in_my_area = User.within(default_range, :origin => current_user)
    followers = users_in_my_area.followers_for(current_user)
    following = users_in_my_area.following_by(current_user)
    other = users_in_my_area - followers - following - [current_user]

    [followers, following, other].each do |users|
      users.map!{ |u| [u.front_name.to_s + '|' + u.city.to_s, "user_#{u.id}"] }
    end

    @data = [[I18n.t('search.group.category'), categories], 
             [I18n.t('search.group.followers_in'), followers],
             [I18n.t('search.group.following_in'), following],
             [I18n.t('search.group.other_people'), other]]
  end

    def default_range
    20
  end

  # Overrides default devise behaviour to provide custom path after admin sign out.
  #
  # @param resource [String] resource name.
  #
  # @return [String] path to redirection after sign out.
  #
  def after_sign_out_path_for(resource)
    if resource.to_sym == :admin
      new_admin_session_path
    else
      super
    end
  end

  # Overrides default devise behaviour to provide custom path after user sign in.
  #
  # @param resource_or_scope [String] resource or scope name.
  #
  # @return [String] path to redirection after sign in.
  #
  def signed_in_root_path(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    if scope.to_sym == :user
      landing_page
    else
      super
    end
  end

  # Returns landing page for user. Doesn't use any redirects.
  # Should be used by logged in users only
  #
  def landing_page
    current_user.registration_complete? ? user_path(current_user) : map_path
  end

  helper_method :landing_page

  protected

  #  Before filter, which should be used in case you want to include Google's Maps API to your page
  #
  def with_google_maps_api
    @include_goole_maps = true
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user
      "devise"
    else
      "application"
    end
  end

end
