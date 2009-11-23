=begin
    OpenPHIN is an opensource implementation of the CDC guidelines for 
    a public health information network.
    
    Copyright (C) 2009  Texas Association of Local Health Officials

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

=end

class Rollcall::RollcallController < ApplicationController
  app_toolbar "rollcall"
  helper :rollcall

  before_filter :rollcall_required, :except => :about

  def about
  end

  def index
    toolbar = current_user.roles.include?(Role.find_by_name('Rollcall')) ? "rollcall" : "application"
    Rollcall::RollcallController.app_toolbar toolbar
    @districts = current_user.jurisdictions.map(&:school_districts).flatten!
    if @districts.empty? || !current_user.roles.include?(Role.find_by_name('Rollcall'))
      flash[:notice] = "You do not currently have any school districts in your jurisdiction enrolled in Rollcall.  Email your OpenPHIN administrator for more information."
      render "about"
    end
  end
end
