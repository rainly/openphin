class Rollcall::AttendancesController < ApplicationController
  helper :rollcall
  before_filter :rollcall_required
  before_filter :set_toolbar

  def show
    @attendance = Attendance.new
  end
  
  def create
    @attendance = Attendance.new(params[:attendance])
    @attendance.school_id = nil unless current_user.schools.include?(@attendance.school)
    if @attendance.save
      flash[:notice] = 'Successfully submitted this attendance report'
      redirect_to rollcall_path
    else
      render :show
    end
  end

  protected
  def set_toolbar
    toolbar = current_user.roles.include?(Role.find_by_name('Rollcall')) ? "rollcall" : "application"
    Rollcall::SchoolsController.app_toolbar toolbar
  end

  private
  include RollcallHelper
end
