class User < ApplicationRecord
  include Clearance::User
  include Maawol::Models::Concerns::Subscribable
  include Maawol::Models::Concerns::Mailable

  COMPLIMENTARY_ACCOUNT_LIMIT = 5

  attr_accessor :existing_password, :email_confirm

  has_many :watch_laters
  has_many :favourites
  has_many :views
  has_many  :subscriptions, class_name: 'UsersSubscription'
  has_and_belongs_to_many :lessons
  belongs_to  :author, optional: true

  mount_uploader :avatar, AvatarUploader

  enum	status: [:free, :paying, :complimentary, :deleted, :expiring]

  validates_presence_of :first_name, :last_name, :email
  validate :within_complimentary_account_limit, on: :update

  before_create :set_default_status
  after_create  :add_to_mailchimp
  after_create  :send_welcome_email
  after_create  :send_admin_registration_email

  def self.active
    where.not(status: :deleted)
  end

  def set_default_status
    self.status = :free
  end

  def membership_status
    self.status.to_s.capitalize
  end

  def in_favourites(lesson)
    self.favourites.map(&:lesson_id).include?(lesson.id)
  end

  def in_views(lesson)
    self.views.map(&:lesson_id).include?(lesson.id)
  end

  def in_watch_laters(lesson)
    self.watch_laters.map(&:lesson_id).include?(lesson.id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    self.username || self.first_name
  end

  def has_full_account?
    @has_full_account ||= begin
      user_status = self.status.to_sym
    	if [:paying, :complimentary].include?(user_status)
       true
      elsif user_status == :expiring
        if self.current_ending_subscription.present?
          true
        else
          self.update_attribute(:status, :free)
          false
        end
      else
        false
      end
    end
  end

  def can_download_files_without_purchase?
    self.is_subscriber? || self.is_admin?
  end

  def can_access_dashboard?
    has_full_account? || is_admin?
  end

  def within_complimentary_account_limit
    if (self.status.to_sym == :complimentary) && (current_complimentary_account_count >= COMPLIMENTARY_ACCOUNT_LIMIT)
      errors.add(:base, "You may only set up to #{COMPLIMENTARY_ACCOUNT_LIMIT} accounts as complimentary.")
    end
  end

  def current_complimentary_account_count
    self.class.where(status: :complimentary).all.size
  end
end