class UsersController < FrontEndController

  before_filter :authenticate_user!, :with_google_maps_api
  before_filter :find_user
  before_filter :load_data_for_checkbox

  def show    
    @review = Review.new
    @reviews = @user.reviews
  end

  def address_toggle    
    @user.update_attributes(:address_visible => params[:value]) if @user == current_user
  end

  def following_followers
    @following = User.following_by @user
    @followers = User.followers_for @user
    render :layout => false
  end
  
  protected
    def find_user
      @user = User.find(params[:id])
    end

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