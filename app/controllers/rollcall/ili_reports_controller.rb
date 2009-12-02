class Rollcall::IliReportsController < ApplicationController
  helper :rollcall
  before_filter :rollcall_required
  before_filter :set_toolbar

  def show
    @ili_report = IliReport.new
  end

  def create
    @ili_report = IliReport.new(params[:ili_report])
    @ili_report.school_id = nil unless current_user.schools.include?(@ili_report.school)
    if @ili_report.save
      flash[:notice] = 'Successfully submitted this ILI report'
      redirect_to rollcall_path
    else
      render :show
    end
  end

  protected
  def set_toolbar
    toolbar = current_user.roles.include?(Role.find_by_name('Rollcall')) ? "rollcall" : "application"
    self.class.app_toolbar toolbar
  end

  private
  include RollcallHelper
end