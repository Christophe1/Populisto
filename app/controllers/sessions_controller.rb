class SessionsController < Devise::SessionsController
  skip_before_filter :redirect_if_mobile

  # POST /resource/sign_in
  def create
    unless User.find_by_email(params[:user][:email])
      auth_options = {:scope => :company, :recall => 'sessions#new'}
      resource_name = :company
      warden.config[:default_scope] = :company
      params[:company] = params.delete(:user)
      resource_name = :company
    else
      resource_name = :user
      auth_options = {:scope => :user, :recall => 'sessions#new'}
    end
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end

