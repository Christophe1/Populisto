class ReviewsController < FrontEndController
  before_filter :check_resource!
  respond_to :html, :json

  before_filter :with_google_maps_api

  def index
    @cats = []
    user = User.unscoped.find(current_resource.id)
    @review = user.reviews.new
    @user_latitude = current_resource.lat
    @user_longitude = current_resource.lng
    Category.filtered.order(:name).map{|c| @cats << c}
    first_cat = Category.unscoped.find(1)
    @cats.unshift(first_cat)
  end

  def create
    @review = Review.create((params[:review] || {}).merge(:user_id => current_resource.id))
    if @review.save
      redirect_to landing_page, :notice => I18n.t('write_review.review_successfully_created')
    else
      render :action => :index
    end
  end

  def suggest_category
    categories = params[:category]
    ReviewEmail.suggest_category(current_resource, categories).deliver
  end

  def suggest_category_form

  end

  def show
    @review = current_resource.reviews.find(params[:id])
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])

    else
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end

  def repost
    @review = Review.find(params[:id])
    @review.repost(current_resource)
  end

  def reject
    @review = Review.find(params[:id])
    current_user.reject @review
  end
end
