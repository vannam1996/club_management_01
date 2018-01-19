class Club < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  acts_as_taggable
  attr_accessor :image_width, :image_height

  has_many :user_clubs, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :users, through: :user_clubs
  has_many :target_hobbies_tags, as: :target, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :ratings, as: :rateable
  has_many :notifications, as: :target, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :activities, as: :container, dependent: :destroy
  has_many :user_organizations, through: :organization
  has_many :statistic_reports, dependent: :destroy
  has_many :warning_reports, dependent: :destroy

  belongs_to :organization
  belongs_to :club_type

  mount_uploader :image, ImageUploader
  mount_uploader :logo, ImageUploader

  serialize :time_activity, Array

  validates :name, presence: true, uniqueness: true,
    length: {maximum: Settings.club.max_name_length}
  validates :content, presence: true
  validates :goal, presence: true
  validate :check_dimensions, on: :update

  # enum club_type: {sport: 1, game: 2, education: 3, music: 4,
  #   entertainment: 5, confidential: 6, junket: 7, other: 0}

  # scope :actives, ->{where is_active: true}
  scope :of_user_clubs, ->user_clubs{where id: user_clubs.map(&:club_id)}
  scope :newest, ->{order created_at: :desc}
  scope :without_clubs, ->clubs{where.not(id: clubs.ids)}
  scope :of_organizations, ->organizations do
    where(organization_id: organizations.ids)
  end
  scope :not_report, ->ids{where id: ids}

  delegate :name, to: :organization, prefix: true, allow_nil: :true

  def calculate_change_budget event
    self.update_attributes money: self.money.to_i - event.expense.to_i
  end

  def calculate_get_budget event, size_member
    self.update_attributes money: size_member * event.expense.to_i + self.money.to_i
  end

  def pay_money_change event, change
    self.update_attributes money: self.money.to_i + (event.expense.to_i - change.to_i)
  end

  def rating_club
    self.rating.round.times do
      safe_join "<i class='fa fa-star'></i>"
    end
  end

  class << self
    def create_after_approve request
      club = self.create organization_id: request.organization_id, name: request.name,
        description: request.description, member: request.member, goal: request.goal,
        local: request.local, content: request.content, time_activity: request.time_activity,
        rules: request.rules, rule_finance: request.rule_finance, time_join: request.time_join,
        punishment: request.punishment, plan: request.plan, logo: request.logo, is_active: true,
        club_type: request.club_type, activities_connect: request.activities_connect
      create_user_club club, request
      add_member_club club, request
    end

    def create_user_club club, request
      user_club = UserClub.create user_id: request.user_id, club_id: club.id, is_manager: true,
        status: :joined
      send_mail_club_request user_club, club
    end

    def add_member_club club, request
      user_ids = UserClubRequest.user_club_requests(request.id).pluck(:user_id)
      if user_ids
        userclubs = []
        user_ids.each do |user_id|
          userclubs << UserClub.new(user_id: user_id, club_id: club.id, is_manager: false,
            status: :joined)
        end
        UserClub.import userclubs
      end
    end

    def send_mail_club_request user_club, club
      OrganizationMailer.mail_to_club_request(user_club.user, club).deliver_later
    end
  end

  def is_admin? user
    user_club = self.user_clubs.manager.find_by(user_id: user.id)
    user_club.present?
  end

  def money_pay money
    self.update_attributes! money: self.money - money
  end

  def money_subsidy money
    self.update_attributes! money: self.money + money
  end

  def subsidy_money_change event, change
    self.update_attribute :money, self.money.to_i + (change.to_i - event.expense.to_i)
  end

  def check_dimensions
    if !image_cache.nil? && (image.width < Settings.club.image.min_width_image_club ||
      image.height < Settings.club.image.min_height_image_club ||
      image.height > Settings.club.image.max_height_image_club)
      errors.add :image, I18n.t("errors_size_image",
        min_width_image_club: Settings.club.image.min_width_image_club,
        min_height_image_club: Settings.club.image.min_height_image_club,
        max_height_image_club: Settings.club.image.max_height_image_club)
    end
  end

  def display_organization
    return "" if self.nil?
    self.organization_name.to_s
  end

  private
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
