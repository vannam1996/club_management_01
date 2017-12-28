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
        expect(flash[:danger]).to be_present
      end
      it "get with params club fails" do
        get :show, xhr: true, params: {club_id: "abcd", id: statistic_report.id}
        expect(response).to be_ok
      end
    end
  end
end
