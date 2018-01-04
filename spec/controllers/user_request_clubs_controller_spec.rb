require "rails_helper"

RSpec.describe UserRequestClubsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end
  let(:user_club) do
    create :user_club, user: user, club: club, status: "joined"
  end

  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params present" do
      before{get :update, xhr: true, params: {id: user_club, status: "joined"}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :update, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("club_manager.cant_fount")}
    end
  end
  describe "GET #show" do
    context "when params present" do
      before{get :show, xhr: true, params: {id: club}}
      it{expect(response).to be_ok}
    end
    context "when params present" do
      before{get :show, xhr: true, params: {id: club, page: 2}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :show, xhr: true, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("not_found")}
    end
  end
end
