class Ability
  include CanCan::Ability

  def initialize user, controller_namespace
    case controller_namespace
    when Settings.namespace_club_manage
      can :manage, StatisticReport do |report|
        report.club.user_clubs.manager.pluck(:user_id).include? user.id
      end
      can :read, StatisticReport do |report|
        report.club.user_clubs.pluck(:user_id).include? user.id
      end
    else
      can :read, :all

      can :is_admin, Club do |club|
        club.user_clubs.manager.map(&:user_id).include?(user.id)
      end

      can :manage, ClubType do |type|
        type.organization.user_organizations.are_admin.pluck(:user_id)
          .include?(user.id)
      end

      can [:edit, :update, :create], [Club]

      can :manage, [Organization] do |organization|
        organization.user_organizations.are_admin.map(&:user_id).include? user.id
      end

      can :update, [StatisticReport] do |statistic|
        organization = Organization.find_by id: statistic.club.organization.id
        organization.user_organizations.are_admin.pluck(:user_id)
          .include?(user.id)
      end

      can [:create, :update], [StatisticReport] do |statistic|
        club = Club.find_by id: statistic.club_id
        club.user_clubs.manager.map(&:user_id).include?(user.id)
      end

      can :manage, ReportCategory do |category|
        category.organization.user_organizations.are_admin.pluck(:user_id)
          .include?(user.id)
      end

      can :manage, OrganizationSetting do |setting|
        setting.organization.user_organizations.are_admin.pluck(:user_id)
          .include?(user.id)
      end

      can :manage, :event_notification do |club|
        club.keys.first.user_clubs.manager.pluck(:user_id).include?(user.id)
      end

      can :manage, Video do |video|
        video.album.club.user_clubs.manager.pluck(:user_id).include? user.id
      end
    end
  end
end
