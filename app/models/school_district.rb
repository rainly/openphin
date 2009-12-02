# == Schema Information
#
# Table name: school_districts
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  jurisdiction_id :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  hipaa_agreement :boolean(1)
#

class SchoolDistrict < ActiveRecord::Base
  belongs_to  :jurisdiction
  has_many    :schools, :foreign_key => "district_id"
  has_many    :absentee_reports, :through => :schools
  has_many    :daily_infos, :class_name => "SchoolDistrictDailyInfo", :foreign_key => "school_district_id", :order => "report_date asc"

  named_scope :with_hippa_agreement, :conditions => {:hipaa_agreement => true}

  def average_absence_rate(date = Date.today)
    daily_info = daily_infos.for_date(date).first
    daily_info = update_daily_info(date) if daily_info.nil?
    daily_info.absentee_rate 
  end

  def update_daily_info(date)
    daily_infos.create(:report_date => date)
  end

  def recent_absentee_rates(days)
    ((Date.today-(days-1).days)..Date.today).map do |date|
      average_absence_rate(date)
    end
  end
end
