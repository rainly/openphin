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
#  absentee_report_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Attendance do
  before(:each) do
    @valid_attributes = {
      :school_id => 1,
      :date => Date.today,
      :enrollment => 1,
      :absent => 1,
      :absent_ili => 1,
      :left_early => 1,
      :left_early_ili => 1,
      :enrollment_growth => "value for enrollment_growth",
      :closed => false,
      :closed_flu => false,
      :faculty_absent => 1,
      :faculty_absent_ili => 1,
      :comments => "value for comments"
    }
  end

  it "should create a new instance given valid attributes" do
    Attendance.create!(@valid_attributes)
  end
end
