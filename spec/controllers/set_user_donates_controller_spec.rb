require "rails_helper"

RSpec.describe SetUserDonatesController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, status: "joined"
  end
  let(:event) do
    create :event, club: club, user: user
  end
  let(:donate) do
    create :donate, user: user, event: event, status: "joined"
  end
  before do
    sign_in user
  end

  describe "GET #show" do
    context "when params present" do
      before {get :show, xhr: true, params: {club_id: club, event_id: event, id: user}}
      it {expect(response).to be_ok}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {club_id: club, event_id: event, id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("not_found")}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {club_id: 0, event_id: event, id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("not_found")}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {club_id: club, event_id: 0, id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("not_found")}
    end
  end

  describe "GET #index" do
    it "responds successfully" do
      get :index, xhr: true, params: {club_id: club, event_id: event, user: user}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new user club" do
        request_params = FactoryGirl.attributes_for(:donate)
        expect do
          post :create, xhr: true, params: {club_id: club, event_id: event, email: user.email, expense: 100000}
        end.to change(Donate, :count).by 1
      end
      it "create fail with user_id nil" do
        request_params = FactoryGirl.attributes_for :donate
        expect do
          post :create, xhr: true, params: {club_id: club, event_id: event, email: user.email}
        end.to change(UserClub, :count).by 0
        expect(flash[:danger]).to eq I18n.t("donate.unregistered")
      end
    end
    context "when params not present" do
      before {post :create, xhr: true, params: {club_id: club, event_id: event, email: user.email, expense: nil}}
      it {expect(flash[:danger]).to eq I18n.t("donate.unregistered")}
    end
  end
end
