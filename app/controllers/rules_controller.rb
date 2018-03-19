class RulesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization
  before_action :all_rules_and_build_rule, only: :index
  before_action :load_rule, only: [:edit, :update, :destroy]
  authorize_resource

  def index; end

  def create
    @rule = @organization.rules.new rule_params
    if @rule.save
      flash.now[:success] = t "flash_rule.success"
    elsif @rule.errors.any?
      flash_error_ajax @rule
    else
      flash.now[:danger] = t "flash_rule.errors"
    end
    all_rules_and_build_rule
  end

  def edit
    @rule.rule_details.build if (@rule && @rule.rule_details.blank?)
  end

  def update
    if @rule.update_attributes rule_params
      flash.now[:success] = t "flash_rule.success"
    else
      flash.now[:danger] = t "flash_rule.errors"
    end
    all_rules_and_build_rule
  end

  def destroy
    if @rule && @rule.destroy
      flash.now[:success] = t "flash_rule.success"
    else
      flash.now[:danger] = t "flash_rule.errors"
    end
    all_rules_and_build_rule
  end

  private
  def load_organization
    @organization = Organization.find_by slug: params[:organization_id]
    return if @organization
    flash.now[:danger] = t "flash_rule.cant_find_org"
  end

  def rule_params
    params.require(:rule).permit :name, :note, rule_details_attributes:
      [:content, :points, :id, :_destroy]
  end

  def load_rule
    if @organization
      @rule = Rule.find_by id: params[:id]
      return if @rule
      flash.now[:danger] = t "flash_rule.cant_find_rule"
    end
  end

  def all_rules_and_build_rule
    if @organization
      @rules = @organization.rules.newest.includes(:rule_details)
        .page(params[:page]).per Settings.per_page_criteria
      @rule = @organization.rules.build
      @rule.rule_details.build
    end
  end
end
