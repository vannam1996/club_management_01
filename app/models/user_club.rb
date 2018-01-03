class UserClub < ApplicationRecord
  belongs_to :user
  belongs_to :club

  has_many :activities, as: :trackable, dependent: :destroy

  after_update :send_mail_after_update

  enum status: {pending: 0, joined: 1, reject: 2}

  scope :manager, ->{where is_manager: true}
  scope :are_member, ->{where is_manager: false}
  scope :unactive, ->{where.not(status: UserClub.statuses[:joined])}
  scope :user_club, ->club_id do
    where club_id: club_id
  end
  scope :find_with_user_of_club, ->user_id, club_id do
    find_by user_id: user_id, club_id: club_id
  end
  scope :newest, ->{order created_at: :desc}
  scope :by_club, ->club_id{where club_id: club_id}

  class << self
    def of_club club
      find_by club: club
    end

    def verify_manager? user
      user = find_by(id: user.id)
      return user.is_manager if user
      false
    end

    def create_user_club user_id, club_id
      create user_id: user_id, club_id: club_id, is_manager: false,
        status: :joined
    end

    def load_user user_id
      find_by id: user_id
    end
  end

  def send_mail_after_update
    send_email_join_club self if self.joined?
  end

  def send_email_join_club user
    ClubMailer.mail_to_user_join_club(user, user.club).deliver_later if user.club.present?
  end

  def self.open_spreadsheet file
    @errors = []
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else
      @errors = Settings.error_import
    end
  end

  def self.import_file_club file, organization, club
    @users_member = []
    @msg_user_not_exist = ""
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(Settings.read_key_row1)
    (Settings.read_data_row2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.find_by(full_name: row[Settings.row_name])
      user = User.find_by(email: row[Settings.row_email]) unless user
      check_user user, row
    end
    check_users_member organization, club
  end

  def self.check_user user, row
    if user
      @users_member << user
    else
      @msg_user_not_exist += "#{row[Settings.row_name]}, "
    end
  end

  def self.check_users_member organization, club
    if @users_member
      @msg_not_create_success = ""
      @users_member.each do |user|
        if user && UserOrganization.find_by(user_id: user.id, organization_id: organization.id)
          unless UserClub.find_by user_id: user.id, club_id: club.id
            check_create_user_club user, club
          end
        else
          if user && UserOrganization.create_user_organization(user.id, organization.id)
            check_create_user_club user, club
          end
        end
      end
      message_import
    end
  end

  def self.check_create_user_club user, club
    return if create_user_club user.id, club.id
    @msg_not_create_success += "#{user.name}"
  end

  def self.message_import
    case
      when @msg_user_not_exist.present? && @msg_not_create_success.present?
        I18n.t("user_not_exist", names: @msg_user_not_exist) +
          I18n.t("found_create", names: @msg_not_create_success)
      when @msg_user_not_exist.present?
        I18n.t("user_not_exist", names: @msg_user_not_exist)
      when @msg_not_create_success.present?
        I18n.t("found_create", names: @msg_not_create_success)
      else
        I18n.t("msg_null")
    end
  end

  delegate :name, :logo, :notification, :money, to: :club, allow_nil: :true
  delegate :full_name, :avatar, :email, :phone, to: :user, allow_nil: :true
end
