class Company < ActiveRecord::Base
  # attr_accessible :title, :body

  self.table_name = "users"

  extend FriendlyId
  friendly_id :slug_name, :use => :slugged
  acts_as_gmappable :process_geocoding => false, :lat => 'lat', :lng => 'lng'
  acts_as_mappable :default_units => :kms, :default_formula => :sphere

  default_scope where(:is_company => true)
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  attr_accessible :email, :name, :first_name, :last_name, :password_confirmation, :password,
                  :remember_me, :address, :confirmed_at, :lng, :lat, :address_visible, :city, :category_ids

  has_many :reviews, :foreign_key => :user_id

  has_many :friend_relations, :primary_key => :external_user_id,
           :foreign_key => "source_user_id", :dependent => :destroy
  has_many :email_invites, :foreign_key => :from_user_id, :dependent => :destroy

  has_many :genres
  has_many :film_users, :dependent => :destroy
  has_many :films, :through => :film_users

  has_many :category_companies
  has_many :categories, :through => :category_companies

  validates :name, :allow_blank => true, :length => { :maximum => 50 }
  validates_presence_of :name


  def slug_name
    "#{self.name.to_s}"
  end

  def registration_complete?
    self.address.present?
  end

  def front_name
    name
  end

  def invited_emails
    email_invites.pluck(:email).compact.map { |email| [email, email] }
  end

  def facebook_followers_ids
    FriendRelation.facebook.by_target_user(self.external_user_id).pluck(:source_user_id)
  end

  def followers_ids
    @followers_ids ||= begin
      FriendRelation.populisto.by_target_user(self.id).pluck(:source_user_id) +
      FriendRelation.email.by_target_user(self.id).pluck(:source_user_id)
    end
  end

  def facebook_followed_ids
    FriendRelation.facebook.by_source_user(self.external_user_id).pluck(:target_user_id)
  end

  def followed_ids
    @followed_users_ids ||= begin
      FriendRelation.populisto.by_source_user(self.id).pluck(:target_user_id) +
      FriendRelation.email.by_source_user(self.id).pluck(:target_user_id)
    end
  end

  def personal_reviews_contacts
    arr = []
    cat = Category.find(1)
    arr = cat.reviews.where(:user_id => self.id)
  end
end
