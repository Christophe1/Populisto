class HomeController < FrontEndController

  before_filter :check_resource!, :except => :index
  before_filter :check_if_user_not_signed_in, :only => :index
  skip_before_filter :force_address_step, :only => [:index, :map, :update_address]

  before_filter :with_google_maps_api, :only => :map

  after_filter :update_distances_to_other_users, :only => :update_address

  #before_filter :load_data_for_checkbox




  def index
    #render 'users/sessions/coming', :layout => 'devise'
    # render 'users/sessions/new', :layout => 'devise'

  #     @users_count = User.count
  # gon.watch.users_count = @users_counts
  end

  def map
    @review = Review.new
  end

  def update_address
    if current_user
      if params[:changed] == '1'
        current_user.update_attributes(params[:user])
        redirect_to landing_page
      else
        flash[:alert] = I18n.t('map.address_validation')
        redirect_to landing_page
      end
    elsif current_company
      if params[:changed] == '1'
        current_company.update_attributes(params[:company])
        redirect_to landing_page
      else
        flash[:alert] = I18n.t('map.address_validation')
        redirect_to landing_page
      end
    end
  end

  private

  def check_if_user_not_signed_in
    if current_user.present?
      if user_signed_in?
        if current_user.registration_complete?
          redirect_to landing_page
        else
          redirect_to map_path
        end
      end
    elsif current_company.present?
      if company_signed_in?
        if current_company.registration_complete?
          redirect_to landing_page
        else
          redirect_to map_path
        end
      end
    end
  end

  def update_distances_to_other_users
    if current_user
      FriendRelation.update_distances(current_user)
    elsif current_company
      FriendRelation.update_distances(current_company)
    end
  end

  protected

  def check_resource!
    current_user.present? || current_company.present? || redirect_to(root_path)
  end

end
