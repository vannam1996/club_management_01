require "rails_helper"

RSpec.describe  EventsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, status: "joined", is_manager: true
  end
  let(:event) do
    create :event, club: club, user: user
  end

  before do
    sign_in user
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "POST #create" do
    let :event_params do
      {
        event_category: 1,
        name: "abcabc",
        club_id: 1,
        user_id: 1
      }
    end
    context "with params present" do
      before {post :create, params: {club_id: club, event: event_params}}
      it "create new event" do
        expect(flash[:success]).to eq I18n.t("club_manager.event.success_create")
      end
    end
    context "with params present" do
      it "create fail with params[:event][:name] nil" do
        request_params = FactoryGirl.attributes_for :event
        expect do
          post :create, params: {club_id: club, event: {event_category: 0}}
        end.to change(Event, :count).by 0
        expect(flash[:danger]).to eq ["Tên sự kiện  không được bỏ trống",
          "Tên sự kiện  quá ngắn (ít nhất 5 ký tự)"]
      end
    end
    context "with params present" do
      it "create fail with params[:event][:name] nil" do
        request_params = FactoryGirl.attributes_for :event
        expect do
          post :create, params: {club_id: club, event: {event_category: 0, name: "123"}}
        end.to change(Event, :count).by 0
        expect(flash[:danger]).to eq ["Tên sự kiện  quá ngắn (ít nhất 5 ký tự)"]
      end
    end
    context "with params club_id blank" do
      before {post :create, params: {club_id: 0}}
      it "create new event" do
        expect(flash[:danger]).to eq I18n.t("not_found")
      end
    end
  end
  describe "GET #show" do
    let!(:event) do
      create :event, club: club, user: user
    end
    context "when params present" do
      before {get :show, xhr: true, params: {club_id: club, id: event}}
      it {expect(response).to be_ok}
    end
    context "when params present" do
      before {get :show, xhr: true, params: {club_id: club, id: event, page: 2}}
      it {expect(response).to be_ok}
    end
    context "when params present" do
      before {get :show, xhr: true, params: {club_id: club, id: event, comment_status: "all"}}
      it {expect(response).to be_ok}
    end
    context "when params not present" do
      before {get :show, xhr: true, params: {club_id: club, id: 0}}
      it {expect(flash[:danger]).to eq I18n.t("not_found")}
    end
  end
  describe "PATCH #update" do
    let! :event_params do
      {
        event_category: 1,
        name: "qweretr",
        club_id: club.id,
        user_id: user
      }
    end
    let!(:event) do
      create :event, club: club, user: user
    end
    context "when params[:id] not present" do
      before {post :update, params: {id: event, club_id: club, event: event_params}}
      it {expect(flash[:danger]).to eq I18n.t("club_manager.event.success_update")}
    end
    context "when params[:id] not present" do
      before {post :update, params: {id: event, club_id: club, event: nil}}
      it {expect(flash[:danger]).to eq I18n.t("error_in_process")}
    end
    context "when params[:organization_id] present" do
      before {get :update, params: {id: 0, club_id: club, event: nil}}
      it {expect(flash[:danger]).to eq I18n.t "not_found"}
    end
  end
end
