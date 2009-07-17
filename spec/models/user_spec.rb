# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  last_name          :string(255)
#  phin_oid           :string(255)
#  description        :text
#  display_name       :string(255)
#  first_name         :string(255)
#  email              :string(255)
#  preferred_language :string(255)
#  title              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(128)
#  salt               :string(128)
#  token              :string(128)
#  token_expires_at   :datetime
#  email_confirmed    :boolean         not null
#  phone              :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  describe "validations" do
    before(:each) do
      @user = Factory.build(:user)
    end
    
    it "should be valid" do
      @user.valid?.should be_true
    end
    
    it "should not be valid without an email" do
      @user.email = ""
      @user.valid?.should be_false
    end
    
    it "should not be valid without a first name" do
      @user.first_name = ""
      @user.valid?.should be_false
    end

    it "should not be valid without a last name" do
      @user.last_name = ""
      @user.valid?.should be_false
    end

    it "should be invalid if a Person already exists with same email" do
      Factory(:user, :email => "joe@example.com")
      @user.email = "joe@example.com"
      @user.valid?.should be_false
    end
  end

  should_make_fields_accessible :first_name, :last_name, :display_name, :description, :preferred_language, :title
  
  describe "creating a user" do
    before(:each) do
      Role.find_or_create_by_name("Public")
    end
    
    context "when the user is created with role requests" do
      it "should create a public role membership for the jurisdiction of the first role request" do
        jurisdiction = Factory(:jurisdiction)
        user = Factory.build(:user)
        user.role_requests = [Factory.build(:role_request, 
            :role => Factory(:role, :approval_required => true), 
            :jurisdiction => jurisdiction, :requester => user)]
        user.save!
        user.reload
        public_membership = user.role_memberships.detect do |membership|
          membership.jurisdiction == jurisdiction && membership.role == Role.find_by_name!("Public")
        end
         public_membership.should_not be_nil
      end
    end
    
    context "when the user is created without any role requests" do
      it "should not assign a public role membership" do
        user = Factory(:user, :role_requests => [])
        user.role_memberships.should be_empty
      end
    end
  end

  describe "phin_oid" do
    it "should be generated on create" do
      Factory(:user).phin_oid.should_not be_blank
    end
    
    it "should not change when saving" do
      person = Factory(:user)
      lambda {
        person.update_attributes! :first_name => 'changed'
      }.should_not change { person.phin_oid }
    end
    
    it "should not allow assignment" do
      person = Factory(:user)
      lambda { person.phin_oid = 1 }.should raise_error
    end
  end
  
  describe "#is_admin_for?" do
    before(:each) do
      @user = Factory(:user)
      @jurisdiction = Factory(:jurisdiction)
      Factory(:role_membership, :jurisdiction => @jurisdiction, :role => Role.admin, :user => @user)
    end
    
    it "should return true if the user is an admin for the given jurisdiction" do
      @user.is_admin_for?(@jurisdiction).should == true
    end
    
    it "should return false if the user is not an admin for the given jurisdiction" do
      j2=Factory(:jurisdiction)
      @user.is_admin_for?(j2).should == false
    end
  end
  
  describe "display_name" do
    it "should default to full name if display name not specified" do
      user = User.new(:first_name => 'Brandon', :last_name => 'Keepers')
      user.display_name.should == 'Brandon Keepers'
    end
    
    it "should use display name if specified" do
      user = User.new(:first_name => 'Brandon', :last_name => 'Keepers', :display_name => 'bkeepers')
      user.display_name.should == 'bkeepers'
    end
  end
  
  describe "alerter?" do
    it "should return false if user does not have any roles" do
      Factory(:user, :role_memberships => []).alerter?.should be_false
    end

    it "should return false if user does not have an alerter role" do
      user = Factory(:user, :role_memberships => [])
      Factory(:role_membership, :role => Factory(:role, :alerter => false), :user => user)
      user.alerter?.should be_false
    end

    it "should return true if user has an alerter role" do
      user = Factory(:user, :role_memberships => [])
      Factory(:role_membership, :role => Factory(:role, :alerter => true), :user => user)
      user.alerter?.should be_true
    end
  end
  
  describe "alerts_within_jurisdictions" do
    it "should include alerts in user's jurisdictions" do
      user = Factory(:user)
      jurisdiction = Factory(:jurisdiction)
      user.jurisdictions << jurisdiction
      alert = Factory(:alert, :from_jurisdiction => jurisdiction)
      user.alerts_within_jurisdictions.should include(alert)
    end
    
    it "should include alerts in child jurisdictions" do
      user = Factory(:user)
      parent = Factory(:jurisdiction)
      user.jurisdictions << parent
      child = Factory(:jurisdiction)
      child.move_to_child_of parent
      alert = Factory(:alert, :from_jurisdiction => child)
      user.alerts_within_jurisdictions.should include(alert)
    end
    
    it "should not include alerts in other jurisdicitions" do
      user = Factory(:user)
      user.jurisdictions << Factory(:jurisdiction)
      another = Factory(:jurisdiction)
      alert = Factory(:alert, :from_jurisdiction => another)
      user.alerts_within_jurisdictions.should_not include(alert)
    end
  end
end
