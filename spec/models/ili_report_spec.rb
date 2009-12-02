# == Schema Information
#
# Table name: ili_reports
#
#  id                            :integer(4)      not null, primary key
#  school_id                     :integer(4)
#  temperature                   :string(255)
#  onset_date                    :date
#  in_school_at_onset            :boolean(1)
#  grade                         :string(255)
#  zip                           :string(255)
#  gender                        :string(255)
#  student_name                  :string(255)
#  parent_name                   :string(255)
#  address                       :string(255)
#  birthdate                     :date
#  race                          :string(255)
#  phone                         :string(255)
#  doctor_name                   :string(255)
#  doctor_address                :string(255)
#  confirmed_by_physician        :boolean(1)
#  diagnosis                     :string(255)
#  treatment                     :string(255)
#  released_for_return_to_school :boolean(1)
#  created_at                    :datetime
#  updated_at                    :datetime
#

require 'spec_helper'

describe IliReport do
  before(:each) do
    @valid_attributes = {
      :school_id => 1,
      :onset_date => Date.today,
      :in_school_at_onset => false,
      :grade => "value for grade",
      :zip => "value for zip",
      :gender => "value for gender",
      :student_name => "value for student_name",
      :parent_name => "value for parent_name",
      :address => "value for address",
      :birthdate => Date.today,
      :race => "value for race",
      :phone => "value for phone",
      :doctor_name => "value for doctor_name",
      :doctor_address => "value for doctor_address",
      :confirmed_by_physician => false,
      :diagnosis => "value for diagnosis",
      :treatment => "value for treatment",
      :released_for_return_to_school => false
    }
  end

  it "should create a new instance given valid attributes" do
    IliReport.create!(@valid_attributes)
  end
end
