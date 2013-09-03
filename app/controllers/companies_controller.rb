class CompaniesController < FrontEndController
  before_filter :check_resource!

  def show
    @company = Company.find_by_slug(params[:id])
    @review = Review.new
    @reviews = @company.reviews
  end
end
