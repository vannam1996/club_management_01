class Event < ApplicationRecord
  serialize :description

  has_many :news, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :comments, as: :target, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :notifications, as: :target
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :donate, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :event_details, dependent: :destroy

  accepts_nested_attributes_for :event_details, allow_destroy: true

  belongs_to :club
  belongs_to :user
  belongs_to :organization

  after_destroy :update_money
  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: {minimum: Settings.min_name}
  validates :expense, length: {maximum: Settings.max_exspene}
  validates :location, length: {maximum: Settings.max_location}

  scope :top_like, ->{order num_like: :desc}
  scope :of_month_payment, ->month_payment{where month_of_payment: month_payment}
  scope :newest, ->{order created_at: :desc}
  scope :periodic, ->{where event_category: Settings.periodic_category}
  scope :by_current_year, ->{where "year(created_at) = ?", Time.zone.now.year}
  scope :by_quarter, ->months{where("month(created_at) in (?)", months)}
  scope :by_event, ->event_category{where event_category: event_category}
  scope :by_years, ->years{where "year(created_at) = ?", years}
  scope :without_notification, ->category_notification do
    where.not event_category: category_notification
  end
  scope :by_created_at, ->(first_date, end_date) do
    where("DATE(created_at) BETWEEN DATE(?) AND DATE(?)", first_date, end_date)
  end

  scope :in_categories, ->ids{where event_category: ids}
  scope :status_public, ->is_public{where is_public: is_public}

  enum status: {inprocess: 0, finished: 1}
  enum event_category: {pay_money: 1, get_money: 2, notification: 3, subsidy: 0, donate: 4, receive_money: 5}

  delegate :full_name, :avatar, to: :user, prefix: :user
  delegate :name, :logo, :slug, to: :club, prefix: :club

  accepts_nested_attributes_for :albums

  def self.group_by_quarter
    quarters = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    array = Array.new
    quarters.each_with_index do |_quarter, index|
      list_events = self.by_quarter quarters[index]
      array.push list_events
    end
    array
  end

  def cost_expense total
    self.update_attributes expense: self.expense.to_i + self.amount.to_i * total
  end

  def by_user? user
    user.id == self.user_id
  end

  def notification?
    self.event_category == Settings.event_notification
  end

  class << self
    def calculate_get_donate donate
      donate.club.update_attributes money: donate.expense.to_i + donate.club.money.to_i
    end
  end

  def update_money
    if self.pay_money?
      self.club.update_attributes money: self.club.money + self.expense
    elsif !self.notification? && !self.get_money?
      self.club.update_attributes money: self.club.money - self.expense
    end
  end
end
