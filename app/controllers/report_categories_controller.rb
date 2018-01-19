class ReportCategoriesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_organization
  before_action :all_report_categories, except: %i(show new)
  before_action :load_report_category, only: %i(destroy edit update)

  def index; end

  def edit; end

  def update
    if @report_category && @report_category.update_attributes(category_update_params)
      flash.now[:success] = t ".update_success"
    elsif @report_category
      flash.now[:danger] = t ".update_errors"
    end
  end

  def create
    if @organization
      @report_category = @organization.report_categories.new report_category_params
      if @report_category.save
        flash.now[:success] = t ".create_success"
      else
        flash.now[:danger] = t ".create_errors"
      end
    end
  end

  def destroy
    if @report_category && @report_category.report_details.blank?
      if @report_category.destroy
        flash.now[:success] = t ".destroy_success"
      else
        flash.now[:danger] = t ".destroy_errors"
      end
    elsif @report_category
      flash.now[:danger] = t ".exist_repor_details"
    end
  end

  private
  def report_category_params
    params.require(:report_category).permit(:name).merge!(status: :obligatory)
  end

  def category_update_params
    params.permit(:name).merge!(status: params[:status].to_i,
      status_active: params[:status_active].to_i)
  end

  def load_report_category
    @report_category = ReportCategory.find_by id: params[:id]
    return if @report_category
    flash.now[:danger] = t ".find_errors"
  end

  def load_organization
    @organization = Organization.find_by slug: params[:organization_slug]
    return if @organization
    flash.now[:danger] = t ".organization_not_found"
  end

  def all_report_categories
    if @organization
      @report_categories = @organization.report_categories.order_desc.page(params[:page])
        .per Settings.per_page_report_category
    end
  end
end
