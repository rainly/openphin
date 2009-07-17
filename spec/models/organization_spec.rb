# == Schema Information
#
# Table name: organizations
#
#  id                        :integer         not null, primary key
#  name                      :string(255)
#  phin_oid                  :string(255)
#  description               :string(255)
#  fax                       :string(255)
#  locality                  :string(255)
#  postal_code               :string(255)
#  state                     :string(255)
#  street                    :string(255)
#  phone                     :string(255)
#  alerting_jurisdictions    :string(255)
#  primary_organization_type :string(255)
#  type                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  foreign                   :boolean
#  queue                     :string(255)
#  organization_type_id      :integer
#  distribution_email        :string(255)
#  contact_id                :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Organization do
  describe "parent/child relationships" do
    it "should return an array of people from .users" do
      o=Factory(:organization, :name => "APHC")
      p=Factory(:user)
      o.users << p
      o.users.length.should == 1
    end  
  end
  
  describe "finders" do
    describe ".approved" do
      it "should return only approved organizations " do
        unapproved_org = Factory(:organization, :approved => false)
        approved_orgs = [Factory(:organization, :approved => true), Factory(:organization, :approved => true)]
        Organization.approved.should == approved_orgs
      end
    end
  end
end
