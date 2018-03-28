require 'rails_helper'

RSpec.describe Admin::OrganizationsController, type: :controller do
  let!(:admin){create :admin}
  let!(:organization){create :organization}

  before do
    sign_in admin
  end

  describe "get #index" do
    context "with nil params" do
      it "get with params q nil" do
        get :index, xhr: true
        expect(response).to be_ok
      end
    end
    context "with params present" do
      it "get with params q present" do
        get :index, xhr: true, params: {name_or_email_cont: organization.name}
        expect(response).to be_ok
      end
    end
  end

  describe "get #edit" do
    context "with params present" do
      it "get success with params user_id valid" do
        get :edit, xhr: true, params: {id: organization.slug}
        expect(response).to be_ok
      end
      it "get errors with params user_id invalid" do
        get :edit, xhr: true, params: {id: "abcd"}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.org.not_find_org")
      end
    end
  end

  describe "get #show" do
    context "with params present" do
      it "get success with params user_id valid" do
        get :show, xhr: true, params: {id: organization.slug}
        expect(response).to be_ok
      end
      it "get errors with params user_id invalid" do
        get :show, xhr: true, params: {id: "abcd"}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.org.not_find_org")
      end
    end
  end

  describe "get #new" do
    context "with params nil" do
      it "get success" do
        get :new, xhr: true
        expect(response).to be_ok
      end
    end
  end

  describe "post #create" do
    context "with params present" do
      it "create success with params user valid" do
        expect do
          post :create, xhr: true, params: {organization: {name: "name organization",
            email: "mail@gmail.com", phone: "0986325632", location: "da nang",
            description: "description"}}
        end.to change(Organization, :count).by 1
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.org.create_success")
      end
      it "create errors with params user invalid" do
        expect do
          post :create, xhr: true, params: {organization: {name: "",
            email: ""}}
        end.to change(Organization, :count).by 0
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.org.errors")
      end
    end
  end

  describe "patch #update" do
    context "with params present" do
      it "update success with params user valid" do
        patch :update, xhr: true, params: {id: organization.slug, organization: {name: "name organization",
          email: "mail@gmail.com", phone: "0986325632", location: "da nang",
          description: "description"}}
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.org.update_success")
      end
      it "update errors with params user invalid" do
        patch :update, xhr: true, params: {id: organization.slug,
          organization: {name: "", email: ""}}
        expect(response).to be_ok
        expect(flash[:danger]).to eq I18n.t("admin_manage.errors")
      end
    end
  end

  describe "delete #destroy" do
    context "with params present" do
      it "destroy success" do
        expect do
          delete :destroy, xhr: true, params: {id: organization.slug}
        end.to change(Organization, :count).by -1
        expect(response).to be_ok
        expect(flash[:success]).to eq I18n.t("admin_manage.org.destroy_success")
      end
    end
  end
end
