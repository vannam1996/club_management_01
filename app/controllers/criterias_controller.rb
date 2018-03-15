class CriteriasController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization

  def index
    @criterias = @organization.criterias.page(params[:page]).per Settings.per_page_criteria
  end

  def new; end

  def create
    binding.pry
  end

  private
  def load_organization
    @organization = Organization.find_by id: params[:organization_id]
    return if @organization
    flash[:danger] = t "organization_not_found"
  end
end
