require "rails_helper"

RSpec.describe WsmHooksController, type: :controller do
  let!(:user){create :user}

  describe "POST #destroy_user" do
    let :user_params do
      {
        name: user.full_name,
        email: user.email,
        deleted_at: Date.today
      }
    end
    context "when params present" do
      it "destroy success with valid access_token" do
        expect do
          post :destroy_user, body: {user: user_params}.to_json, format: :json,
          params: {access_token: "<access_token>"}
        end.to change(User, :count).by -1
      end

      it "destroy fail with invalid access_token" do
        expect do
          post :destroy_user, body: {user: user_params}.to_json, format: :json,
          params: {access_token: "<access_token>_invalid"}
        end.to change(User, :count).by 0
      end
    end
  end
end
