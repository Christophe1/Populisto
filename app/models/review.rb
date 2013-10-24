# == Schema Information
#
# Table name: reviews
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  author_id   :integer(4)
#  name        :string(255)     not null
#  phone       :string(255)
#  comment     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  visible     :boolean(1)      default(TRUE)
#  address     :string(255)
#  lat         :decimal(12, 9)
#  lng         :decimal(12, 9)
#  repost_from :integer(4)
#

class Review < ActiveRecord::Base

  SUGGESTIONS_COUNT = 10

  has_many :category_reviews, :dependent => :destroy
  has_many :categories, :through => :category_reviews

  #has_many :film_users, :dependent => :destroy
  #has_many :users, :through => :film_users

  belongs_to :user
  belongs_to :company, :foreign_key => :user_id

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :phone, :length => { :maximum => 30 }
  validates :comment, :length => { :maximum => 1000 }
  validates_presence_of :category_ids

  attr_accessible :comment, :name, :phone,
                  :user_id, :category_ids,
                  :address, :lng, :lat,
                  :visible, :repost_from,
                  :search_ids

  attr_accessor :distance, :search_ids

  default_scope :order => 'reviews.created_at DESC'
  scope :start_with, lambda { |word| where("name like ?", "#{word}%") }
  scope :with_categories, includes(:categories)
  scope :with_user, includes(:user)
  scope :by_category, lambda { |category_id| where(:id => CategoryReview.where(:category_id => category_id).pluck(:review_id)) }
  scope :from_followers, lambda { |user| where(:user_id => user.all_friends.map(&:id)) }
  scope :from_facebook_neighbors, lambda { |user| where(:user_id => user.facebook_neighbors.pluck(:id)) }

  before_create :set_author_id

  self.per_page = 10

  # Overrides film string representation.
  #
  def to_s
    name
  end

  def owner
    if self.user.present?
      return user
    elsif self.company.present?
      return company
    end
  end

  # if current_user id is the same as the person who
  # who made the review
  # and the review is set to 'public'
  # only then can every user see the review
  # otherwise, if it is private, only current_user can see it.

  #check out a cleaner way of doing this in stackoverflow, my question,
  #'need assistance with some ruby array code, please'

  def visible_to?(resource)
    if self.visible || self.owner == resource #|| assuming they have an ID
      true
    else
      false
    end
  end

  # Gets genres list.
  #
  def categories_list
    categories.map(&:name).join(", ")
  end

  def repost(other_user)
    review = dup
    review.categories = categories
    review.update_attributes(:user_id => other_user.id, :comment => nil, :repost_from => self.id)
    review.save
  end

  def is_personal_contact?
    self.categories.find_by_name("Personal Contact").present?
  end

  class << self

    #  Prepares scope from search params.
    #  Scope can contain different category_ids, user_ids etc.
    #
    def scoped_by_search_params(params, current_user)
      if params.present?
        filtered_categories_reviews = []
        categories_ids = params.map{|id| id.delete('category_').to_i}
        categories_reviews = Review.with_categories.where(:categories => {:id => categories_ids}) unless categories_ids.blank?

        # check if category review owner is in range of current user, if not, do not include the review in results
        categories_reviews.each do |rev|
          if rev.owner.distance_to(current_user) < 20
            filtered_categories_reviews << rev
          end
        end

        users_ids = params.map{|id| id.delete('user_').to_i}
        user_reviews = Review.where(:user_id => users_ids)

        reviews_ids = params.map{|id| id.delete('review_').to_i}
        personal_reviews = Review.where(:id => reviews_ids)

        return reviews = (personal_reviews + filtered_categories_reviews + user_reviews).uniq
      end
    end

    def from_users_followed_by(user)
      followed_user_ids = "SELECT target_user_id FROM friend_relations
                           WHERE source_user_id = :user_id"
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            :user_id => user.id)
    end

  end

  private

  #  Sets author_id to current user_id
  #
  def set_author_id
    if self.author_id.blank?
      self.author_id = self.user_id
    end
  end



end

