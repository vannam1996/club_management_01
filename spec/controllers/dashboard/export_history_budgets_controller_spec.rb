require "rails_helper"

RSpec.describe Dashboard::ExportHistoryBudgetsController, type: :controller do
  let(:user){create :user}
  let(:organization){create :organization}
  let!(:user_organization) do
    create :user_organization, user: user, organization: organization, is_admin: true
  end
  let(:club){create :club}
  let!(:user_club) do
    create :user_club, user: user, club: club
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when params[:id] present" do
      before{get :index, xhr: true, params: {id: club.id}}
      it{expect(response).to be_ok}
    end
    context "when params[:id] not present" do
      before{get :index, params: {id: 0}}
      it{expect(flash[:danger]).to eq "Không thể tìm thấy câu lạc bộ!"}
    end
  end
end
