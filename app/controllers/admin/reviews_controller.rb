class Admin::ReviewsController < Admin::BaseController
  inherit_resources
  navigation_section :reviews
  paginated

  before_filter :load_categories
  before_filter :with_google_maps_api, :only => [:edit, :new, :update]

  def index
    @reviews = Review.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @review = Review.find(params[:id])
  end

  def edit
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
  end

  def destroy
    #destroy! { collection_url(:page => params[:page]) }
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to admin_reviews_path, :notice => "Review was destroyed"
  end

  protected

  def end_of_association_chain
    Review.with_user.with_categories
  end

  private

  def load_categories
    @categories = Category.all
  end
end