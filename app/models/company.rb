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
                  :remember_me, :address, :confirmed_at, :lng, :lat, :address_visible, :city

  has_many :reviews, :foreign_key => :user_id

  has_many :friend_relations, :primary_key => :external_user_id,
           :foreign_key => "source_user_id", :dependent => :destroy
  has_many :email_invites, :foreign_key => :from_user_id, :dependent => :destroy

  has_many :genres
  has_many :film_users, :dependent => :destroy
  has_many :films, :through => :film_users

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
end
