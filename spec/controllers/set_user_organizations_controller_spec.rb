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
  describe "PATCH #update" do
    let!(:user_organization) do
      create :user_organization, user: user, organization: organization, status: "joined"
    end
    context "when params[:id] not present" do
      before {get :update, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
    context "when params[:organization_id] present" do
      before {get :update, params: {id: organization, roles: ["1","0"]}}
      it {expect(flash[:success]).to eq I18n.t "success_process"}
    end
    context "when params[:organization_id] present" do
      before {get :update, params: {id: organization, roles: nil}}
      it {expect(flash[:danger]).to eq I18n.t "cant_not_update"}
    end
  end

  describe "GET #show" do
    context "when params present" do
      before {get :show, xhr: true, params: {id: organization}}
      it {expect(response).to be_ok}
    end
    context "when params present" do
      before {get :show, xhr: true, params: {id: organization, page: 2}}
      it {expect(response).to be_ok}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end

  describe "GET #edit" do
    context "when params present" do
      before {get :edit, xhr: true, params: {id: organization}}
      it {expect(response).to be_ok}
    end
    context "when params not present" do
      before {get :edit, xhr: true, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
  describe "DELETE #destroy" do
    let!(:user_organization) do
      create :user_organization, user: user, organization: organization, status: "joined"
    end
    context "when params present" do
      before {get :destroy, xhr: true, params: {id: user_organization}}
      it {expect(response).to be_ok}
    end
    context "delete faild" do
      it do
        allow_any_instance_of(UserOrganization).to receive(:destroy).and_return false
        expect do
          delete :destroy, xhr: true, params: {id: user_organization.id}
        end.to change(UserOrganization,:count).by 0
      end
    end
    context "when params not present" do
      before {get :destroy, xhr: true, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
end
