require "rails_helper"

RSpec.describe OrganizationSettingsController, type: :controller do
  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user, organization: organization,
      status: :joined, is_admin: true
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index, xhr: true, params: {organization_slug: organization.slug}
      expect(response).to be_success
    end
  end

  describe "Put #update" do
    let(:organization_setting) do
      create :organization_setting, organization: organization
    end
    context "when params present" do
      it "update success with valid params" do
        post :update, xhr: true, params: {
          organization_slug: organization.slug, id: organization_setting.id,
          settings: {date_remind_month: 3, date_remind_quarter: 2}
        }
        expect(response).to be_ok
        expect(flash[:success]).to be_present
      end
    end
  end
end
