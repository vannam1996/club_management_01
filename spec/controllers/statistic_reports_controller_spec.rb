require "rails_helper"

RSpec.describe StatisticReportsController, type: :controller do

  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:club) do
    create :club, organization: organization
  end
  let!(:user_club) do
    create :user_club, user: user, club: club, status: 1, is_manager: 1
  end
  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "create new statistic report" do
        expect do
          post :create, statistic_report: attributes_for(:statistic_report, club_id: club.id)
        end.to change(StatisticReport, :count).by 1
        expect(flash[:success]).to be_present
      end

      it "create fail with club nil" do
        expect do
          post :create, statistic_report: attributes_for(:statistic_report)
        end.to change(ClubRequest, :count).by 0
        expect(flash[:danger]).to be_present
      end
    end
  end
end
