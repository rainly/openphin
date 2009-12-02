# == Schema Information
#
# Table name: symptoms
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Symptom < ActiveRecord::Base
  has_and_belongs_to_many :ili_reports
end
