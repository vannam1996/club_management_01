require "rails_helper"

RSpec.describe SetUserClubsController, type: :controller do

  let(:user){create :user}
  let(:user2){create :user}
  let(:organization){create :organization}
  let(:club) do
    create :club, organization: organization
  end
  let(:user_club) do
    create :user_club, user: user, club: club, status: "joined"
  end
  let(:user_club2) do
    create :user_club, user: user2, club: club, status: "joined"
  end
  before do
    sign_in user
  end

  describe "PATCH #update" do
    context "when params[:club_id] present" do
      before {get :update, params: {id: club.id}}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
    context "when params[:id] not present" do
      before {get :update, params: {id: 0}}
      it {expect(flash[:danger]).to eq "Câu lạc bộ này không tồn tại"}
    end
    context "when params[:club_id] present" do
      before {get :update, params: {id: club.id, roles: ["1","0"]}}
      it {expect(assigns(:user_club)).to eq [user_club, user_club2]}
      it {expect(flash[:success]).to eq "Bạn đã xử lý thành công"}
    end
  end
end
