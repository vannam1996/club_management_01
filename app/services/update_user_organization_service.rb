class UpdateUserOrganizationService
  def initialize user_organizations, params_roles
    @user_organizations = user_organizations
    @roles = params_roles
  end

  def update_user
    @user_organization_update = []
    @user_organizations.each.with_index(Settings.user_club.number) do |member, index|
      if member.is_admin != @roles[index]
        member.is_admin = @roles[index]
        @user_organization_update << member
      end
    end
  end
end
