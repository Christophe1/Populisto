class CreateCategoryCompanies < ActiveRecord::Migration
  def change
    create_table :category_companies do |t|
      t.integer :category_id
      t.integer :company_id

      t.timestamps
    end
  end
end
