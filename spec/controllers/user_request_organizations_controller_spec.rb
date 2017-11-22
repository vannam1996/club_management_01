require "rails_helper"

RSpec.describe UserRequestOrganizationsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user, organization: organization, status: "joined"
  end

  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params present" do
      before {get :update, xhr: true, params: {id: user_organization, status: "joined"}}
      it {expect(response).to be_ok}
    end
    context "when params present" do
      before {get :update, xhr: true, params: {id: user_organization, status: "abc"}}
      it {expect(response).to be_ok}
    end
    context "when params status present" do
      it do
        allow_any_instance_of(UserOrganization).to receive(:update).and_return false
        expect do
          patch :update, xhr: true, params: {id: user_organization.id}
        end.to change(UserOrganization,:count).by 0
      end
    end
    context "when params not present" do
      before {get :update, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
  describe "GET #show" do
    context "when params present" do
      before {get :show, xhr: true, params: {id: organization}}
      it {expect(response).to be_ok}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
  describe "GET #edit" do
    context "when params present" do
      before {get :edit, params: {id: organization}}
      it {expect(flash[:danger]).to eq I18n.t("success_process")}
    end
    context "when params not present" do
      before {get :edit, params: {id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end
end
