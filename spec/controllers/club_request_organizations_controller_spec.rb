require "rails_helper"

RSpec.describe ClubRequestOrganizationsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user, organization: organization, is_admin: true
  end
  let!(:club_request) do
    create :club_request, user: user, organization: organization
  end

  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params[:id] and status present" do
      before{get :update, params: {id: club_request.id, status: 1}}
      it{expect(flash[:success]).to eq I18n.t("success_process")}
    end
    context "when params[:id] and status present" do
      before{get :update, params: {id: club_request.id, status: 2}}
      it{expect(flash[:success]).to eq I18n.t("success_process")}
    end
    context "update failed " do
      before do
        allow_any_instance_of(ClubRequest).to receive(:save).and_return false
        get :update, params: {id: club_request.id, status: 1}
      end
      it{expect(flash[:danger]).to eq I18n.t("error_process")}
    end
  end

  describe "GET #show" do
    context "when params present" do
      before{get :show, xhr: true, params: {id: organization}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :show, xhr: true, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("organization_not_found")}
    end
  end

  describe "GET #edit" do
    context "when params[:id] present" do
      before{get :edit, xhr: true, params: {id: club_request}}
      it{expect(response).to be_ok}
    end
    context "when params[:id] not present" do
      before{get :edit, xhr: true, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("not_found_request")}
    end
  end
end
