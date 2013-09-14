class CompaniesController < FrontEndController
  before_filter :check_resource!

  def show
    param = params[:id] || params[:slug]
    @resource = Company.find_by_slug(params[:id])
    @review = Review.new
    @reviews = @resource.reviews
  end
end
