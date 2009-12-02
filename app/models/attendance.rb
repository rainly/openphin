# == Schema Information
#
# Table name: attendances
#
#  id                 :integer(4)      not null, primary key
#  school_id          :integer(4)
#  date               :date
#  enrollment         :integer(4)
#  absent             :integer(4)
#  absent_ili         :integer(4)
#  left_early         :integer(4)
#  left_early_ili     :integer(4)
#  enrollment_growth  :string(255)
#  closed             :boolean(1)
#  closed_flu         :boolean(1)
#  faculty_absent     :integer(4)
#  faculty_absent_ili :integer(4)
#  comments           :text
#  created_at         :datetime
#  updated_at         :datetime
#

class Attendance < ActiveRecord::Base
  GrowthOptions = ['Increasing', 'Staying the same', 'Decreasing']
  
  belongs_to :school
  belongs_to :absentee_report
  
  validates_presence_of :school_id
  validates_presence_of :date
  
  after_save :save_absente_report

  def save_absente_report
    self.absentee_report ||= AbsenteeReport.new
    self.absentee_report.update_attributes :school => school,
      :report_date => date,
      :enrolled => enrollment,
      :absent => absent
  end
end
