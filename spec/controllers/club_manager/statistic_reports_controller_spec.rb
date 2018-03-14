require "rails_helper"

RSpec.describe ClubManager::StatisticReportsController, type: :controller do
  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, is_manager: true
  end

  before do
    sign_in user
  end

  describe "get #index" do
    context "with params" do
      it "get with params q nil" do
        get :index, xhr: true, params: {club_id: club.slug}
        expect(response).to be_ok
      end
      it "get with params q" do
        get :index, xhr: true, params: {club_id: club.slug, q: {style_eq: 1, time_eq: 1}}
        expect(response).to be_ok
      end
      it "get with params club fails" do
        get :index, xhr: true, params: {club_id: "abcd"}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("error_load_club")
      end
    end
  end

  describe "get #show" do
    let(:statistic_report) do
      create :statistic_report, club: club, user: user
    end
    context "with params" do
      it "get with params true" do
        get :show, xhr: true, params: {club_id: club.slug, id: statistic_report.id}
        expect(response).to be_ok
      end
      it "get with params false" do
        get :show, xhr: true, params: {club_id: club.slug, id: statistic_report.id + 1}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("error_find_report")
      end
      it "get with params club fails" do
        get :show, xhr: true, params: {club_id: "abcd", id: statistic_report.id}
        expect(response).to be_ok
      end
    end
  end

  describe "put #update" do
    let(:statistic_report) do
      create :statistic_report, club: club, user: user
    end
    context "with params" do
      it "update with params month present" do
        report_params = {item_report: "item_report", detail_report: "detail_report",
          plan_next_month: "plan_next_month", style: "1"}
        put :update, xhr: true, params: {statistic_report: report_params, month: "5",
          club_id: club.slug, id: statistic_report.id}
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("update_report_success")
      end
      it "update with params quarter present" do
        report_params = {item_report: "item_report", detail_report: "detail_report",
          plan_next_month: "plan_next_month", style: "2"}
        put :update, xhr: true, params: {statistic_report: report_params, quarter: "4",
          club_id: club.slug, id: statistic_report.id}
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("update_report_success")
      end
      it "update with params id invalid" do
        report_params = {item_report: "", detail_report: "",
          plan_next_month: "plan_next_month", style: "1"}
        put :update, xhr: true, params: {statistic_report: report_params, month: "5",
          club_id: club.slug, id: statistic_report.id + 1}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("error_find_report")
      end
      it "update with params invalid" do
        report_params = {item_report: "", detail_report: "",
          plan_next_month: "", style: "1"}
        put :update, xhr: true, params: {statistic_report: report_params, month: "5",
          club_id: club.slug, id: statistic_report.id}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("update_report_error")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:statistic_report) do
      create :statistic_report, club: club, user: user
    end
    context "when params present" do
      it "destroy success with valid id" do
        post :destroy, xhr: true, params: {club_id: club.slug, id: statistic_report.id}
        expect(flash[:success]).to eq I18n.t("success_process")
        expect(response).to be_ok
      end
      it "destroy success with invalid id" do
        post :destroy, xhr: true, params: {club_id: club.slug, id: statistic_report.id + 1}
        expect(flash[:danger]).to eq I18n.t("error_find_report")
        expect(response).to be_ok
      end
      it "destroy success with invalid id club" do
        post :destroy, xhr: true, params: {club_id: "abcd", id: statistic_report.id}
        expect(flash[:danger]).to eq I18n.t("error_load_club")
        expect(response).to be_ok
      end
    end
  end
end
