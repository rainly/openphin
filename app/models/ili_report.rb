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

class IliReport < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :symptoms
end
