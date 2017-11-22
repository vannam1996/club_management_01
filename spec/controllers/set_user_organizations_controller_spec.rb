require "rails_helper"

RSpec.describe SetUserOrganizationsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let(:user_organization) do
    create :user_organization, user: user, organization: organization, status: "joined"
  end
  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new user club" do
        request_params = FactoryGirl.attributes_for(:user_organization)
        expect do
          post :create, params: {user_id: [user.id], id: organization.slug}
        end.to change(UserOrganization, :count).by 1
        expect(flash[:success]).to be_present
      end

      it "create fail with user_id nil" do
        request_params = FactoryGirl.attributes_for :user_organization, user_id: nil
        expect do
          post :create, params: {id: organization.slug}
        end.to change(UserOrganization, :count).by 0
        expect(flash[:danger]).to be_present
      end
    end
    context "when params[:id] not present" do
      before {get :create, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
end
