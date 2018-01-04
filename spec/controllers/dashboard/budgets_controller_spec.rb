require "rails_helper"

RSpec.describe Dashboard::BudgetsController, type: :controller do
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

  describe "GET #show" do
    context "when params[:id] present" do
      before do
        get :show, xhr: true, params: {id: club.id,
          date_search: {first_date: "2/8/2016", second_date: "8/8/2017"}}
      end
      it{expect(response).to be_ok}
    end
    context "when params[:id] not present" do
      before do
        get :show, params: {id: 0,
          date_search: {first_date: "2/8/2016", second_date: "8/8/2017"}}
      end
      it{expect(flash[:danger]).to eq "Không thể tìm thấy câu lạc bộ!"}
    end
  end
end
