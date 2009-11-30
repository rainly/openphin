# == Schema Information
#
# Table name: absentee_reports
#
#  id          :integer(4)      not null, primary key
#  school_id   :integer(4)
#  report_date :date
#  enrolled    :integer(4)
#  absent      :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class AbsenteeReport < ActiveRecord::Base
  SEVERITY = {
      :low => 0.11000...0.14000,
      :medium => 0.14000...0.25000,
      :high => 0.25000..1.000
      }
  belongs_to :school
  has_one :district, :through => :school

  named_scope :for_date, lambda{ |date|
    {
        :conditions => {:report_date => date}
    }
  }
  named_scope :for_date_range, lambda{ |start, finish|
    {
        :conditions => ["report_date >= ? and report_date <= ?", start, finish],
        :order => "report_date desc"
    }
  }
  named_scope :recent, lambda{|limit| {:limit => limit, :order => "report_date DESC"}}
  named_scope :recent_alerts_by_severity, lambda{|limit| {
      :limit => limit.to_i,
      :conditions => "(absent/enrolled) >= #{SEVERITY[:low].first}",
      :order => "(absent/enrolled) DESC"}}

  named_scope :absenses, lambda{{:conditions => ['absentee_reports.absent / absentee_reports.enrolled >= .11']}}
  named_scope :with_severity, lambda{|severity|
    { :conditions => ["(absent / enrolled) >= ? and (absent / enrolled) < ?", SEVERITY[severity].first, SEVERITY[severity].last]
    }}

  def absentee_percentage
    ((absent.to_f / enrolled.to_f) * 100).to_f.round(2)
  end

  def severity    
    case absentee_percentage / 100
    when SEVERITY[:low] then 'low'
    when SEVERITY[:medium] then 'medium'
    when SEVERITY[:high] then 'high'
    end
  end
end
