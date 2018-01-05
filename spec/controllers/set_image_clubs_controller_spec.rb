require "rails_helper"

RSpec.describe SetImageClubsController, type: :controller do
  let!(:user){create :user}
  let!(:organization){create :organization}
  let!(:club) do
    create :club, organization: organization
  end

  before do
    sign_in user
  end

  describe "GET #show" do
    context "when params present" do
      before{get :show, xhr: true, params: {id: club}}
      it{expect(response).to be_ok}
    end
    context "when params not present" do
      before{get :show, xhr: true, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("not_found")}
    end
  end

  describe "PATCH #update" do
    context "when params present" do
      before do
        get :update, params: {id: club,
        club: {image: "/uploads/image/url/129/full-hd-wallpapers-1920x1080-free-download-2.jpg"}}
      end
      it{expect(flash[:danger]).to eq nil}
    end
    context "when params not present" do
      before{get :update, params: {id: 0}}
      it{expect(flash[:danger]).to eq I18n.t("not_found")}
    end
    context "when params blank" do
      before do
        get :update, params: {id: club, club: {image: nil}}
      end
      it{expect(flash[:danger]).to eq ["Ảnh bìa Lỗi định dạng"]}
    end
    context "when params blank" do
      before do
        get :update, params: {id: club, club: nil}
      end
      it{expect(flash[:danger]).to eq "Chưa có hình ảnh nào được chọn, vui lòng chọn hình ảnh!"}
    end
  end
end
