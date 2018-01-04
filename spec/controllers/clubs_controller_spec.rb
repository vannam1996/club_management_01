require "rails_helper"

RSpec.describe ClubsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user,
      organization: organization, status: 1, is_admin: 1
  end

  before do
    sign_in user
  end

  describe "GET #new" do
    it "responds successfully" do
      xhr :get, :new, params: {organization_id: organization.id}
      expect(response).to be_ok
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new club" do
        expect do
          post :create, params: {id: organization.id, organization_id: organization.slug,
            club: attributes_for(:club)}
        end.to change(Club, :count).by 1
        expect(flash[:success]).to eq I18n.t("success_create_club")
      end
    end
    it "create new fail club" do
      expect do
        post :create, params: {id: organization.id, organization_id: organization.slug}
      end.to change(Club, :count).by 0
      expect(flash[:danger]).to be_present
    end
  end
end
