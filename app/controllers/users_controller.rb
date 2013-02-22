class UsersController < FrontEndController

  before_filter :authenticate_user!, :with_google_maps_api
  before_filter :find_user

  def show    
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
