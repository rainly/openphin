class DevicesController < ApplicationController
  before_filter {|controller| controller.admin_or_self_required(:user_id)}
  protect_from_forgery :except => :create
  
  def destroy
    @device = Device.find(params[:id])
    @device.destroy
    begin
      redirect_to :back
    rescue
      redirect_to dashboard_path
    end
  end

  def create
    user = User.find(params[:user_id])
    @device = "Device::#{params[:device_type]}".constantize.new(params[params[:device_type]])
    @device.user=user
    if @device.save
      render :partial => "device/#{params[:device_type].snake_case.pluralize}/#{params[:device_type].snake_case}", :object => @device, :locals => {:in_form => true}, :status => :created
    else
      render :text => @device.errors.full_messages, :status => 403
    end

  end

end
