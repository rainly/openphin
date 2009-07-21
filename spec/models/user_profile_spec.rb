# == Schema Information
#
# Table name: user_profiles
#
#  id          :integer         not null, primary key
#  photo       :binary
#  public      :boolean
#  credentials :text
#  employer    :string(255)
#  experience  :text
#  bio         :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserProfile do
  before(:each) do
    
    @profile=Factory(:user_profile, :user => Factory(:user))
  end

  it "should create a new instance" do
    @profile.should be_valid
  end
end
