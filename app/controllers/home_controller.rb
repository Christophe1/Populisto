class HomeController < FrontEndController

  before_filter :check_resource!, :except => :index
  before_filter :check_if_user_not_signed_in, :only => :index
  skip_before_filter :force_address_step, :only => [:index, :map, :update_address]

  before_filter :with_google_maps_api, :only => :map

  # after_filter :update_distances_to_other_users, :only => :update_address
  # TODO undefined method `lat' for nil:NilClass when using the above filter

  #before_filter :load_data_for_checkbox

  def index
    render 'users/sessions/new'
  end

  def map
    @review = Review.new
  end

  def update_address
    if params[:changed] == '1'
      if current_user
        current_resource.update_attributes(params[:user])
      elsif current_company
        current_resource.update_attributes(params[:company])
      end
      redirect_to landing_page
    else
      flash[:alert] = I18n.t('map.address_validation')
      redirect_to landing_page
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
end
