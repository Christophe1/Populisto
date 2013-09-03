class CompaniesController < FrontEndController
  before_filter :authenticate_company!

  def show
    @company = Company.find_by_slug(params[:id])
    @review = Review.new
    @reviews = @company.reviews
  end
end
