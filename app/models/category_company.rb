class CategoryCompany < ActiveRecord::Base
  attr_accessible :category_id, :company_id
  belongs_to :company
  belongs_to :category
end
