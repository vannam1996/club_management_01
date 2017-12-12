class Ability
  include CanCan::Ability

  def initialize user
    can :read, :all
    can :is_admin, Club do |club|
      club.user_clubs.manager.map(&:user_id).include?(user.id)
    end
    can [:edit, :update], [Club]
  end
end
