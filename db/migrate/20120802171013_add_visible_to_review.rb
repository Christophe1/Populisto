class AddVisibleToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :visible, :boolean, :null => true, :default => false
  end
end
