class AddReviewsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reviews_count, :integer, :default => 0
    User.reset_column_information
    User.all.map{|u| User.reset_counters(u.id, :reviews)}
  end
end
