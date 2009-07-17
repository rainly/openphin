# == Schema Information
#
# Table name: alerts
#
#  id                     :integer         not null, primary key
#  title                  :string(255)
#  message                :text
#  severity               :string(255)
#  status                 :string(255)
#  acknowledge            :boolean
#  author_id              :integer
#  created_at             :datetime
#  updated_at             :datetime
#  sensitive              :boolean
#  delivery_time          :integer
#  sent_at                :datetime
#  message_type           :string(255)
#  program_type           :string(255)
#  from_organization_id   :integer
#  from_organization_name :string(255)
#  from_organization_oid  :string(255)
#  identifier             :string(255)
#  scope                  :string(255)
#  category               :string(255)
#  program                :string(255)
#  urgency                :string(255)
#  certainty              :string(255)
#  jurisdictional_level   :string(255)
#  references             :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Alert do
  
  describe "status" do
    ['Actual', 'Exercise', 'Test'].each do |status|
      it "should be valid with #{status.inspect}" do
        alert = Factory.build(:alert, :status => status)
        alert.should be_valid
      end
    end

    [nil, '', 'Shout Out'].each do |status|
      it "should be invalid with #{status.inspect}" do
        alert = Factory.build(:alert, :status => status)
        alert.should_not be_valid
        alert.errors.on(:status).should_not be_nil
      end
    end
  end
  
  describe "severity" do
    ['Extreme', 'Severe', 'Moderate', 'Minor', 'Unknown'].each do |severity|
      it "should be valid with #{severity.inspect}" do
        alert = Factory.build(:alert, :severity => severity)
        alert.valid?
        alert.should be_valid
      end
    end

    [nil, '', 'Bogus'].each do |severity|
      it "should be invalid with #{severity.inspect}" do
        alert = Factory.build(:alert, :severity => severity)
        alert.should_not be_valid
        alert.errors.on(:severity).should_not be_nil
      end
    end
  end
  
  describe "delivery_time" do
    [15, 60, 1440, 4320].each do |delivery_time|
      it "should be valid with #{delivery_time.inspect}" do
        alert = Factory.build(:alert, :delivery_time => delivery_time)
        alert.valid?
        alert.should be_valid
      end
    end

    [nil, '', 'Bogus', 0].each do |delivery_time|
      it "should be invalid with #{delivery_time.inspect}" do
        alert = Factory.build(:alert, :delivery_time => delivery_time)
        alert.should_not be_valid
        alert.errors.on(:delivery_time).should_not be_nil
      end
    end
  end
  
  describe "acknowledge" do
    it "should default to true" do
      a = Alert.new
      a.acknowledge?.should == true
    end
    
    it "should allow override" do
      Alert.new(:acknowledge => false).acknowledge?.should == false
    end
  end
  
  describe "device_types=" do
    before do
      @alert = Factory(:alert)
    end

    it "should create an association for the given device types" do
      @alert.device_types = ['Device::EmailDevice']
      lambda { @alert.save }.should change { @alert.alert_device_types.count }
    end
    
    it "should create an association for the given device types" do
      @alert.alert_device_types.create! :device => 'Device::EmailDevice'
      @alert.device_types = []
      @alert.alert_device_types.count.should == 0
    end
  end
  
  describe "device_types" do
    before do
      @alert = Factory(:alert)
    end

    it "should return the names of the device types" do
      @alert.alert_device_types.create! :device => 'Device::EmailDevice'
      @alert.device_types.should == ['Device::EmailDevice']
    end
  end
  
  describe "message_type" do
    before do
      @alert = Factory(:alert)
    end
    
    it "should have a default of 'Alert'" do
      @alert.message_type.should == 'Alert'
    end
  end

end
