Given "an alert with:" do |table|
  alert = Factory(:alert)
  table.rows_hash.each do |key, value|
    case key
    when 'identifier'
      alert.send("#{key}=", value)
    when 'People'
      names = value.split(',')
      alert.users += names.map{|name| Given "a user named #{name}" }
    end
  end
  alert.save!
end

Given 'an alert identified by $identifier' do |identifier|
  Alert.find_by_identifier!(identifier)
end

When 'I view the alert identified by $identifier' do |identifier|
  visit alert_path(Given("an alert identified by #{identifier}"))
end

When 'I login as the author of the alert identified by $identifier' do |identifier|
  author = Given('an alert identified by $identifier').author
  Given %Q|I am logged in as "#{author.email}"|
end

When "PhinMS delivers the message: $filename" do |filename|
  xml = File.read("#{Rails.root}/spec/fixtures/#{filename}")
  EDXL::Message.parse(xml)
end

When "I fill out the alert form with:" do |table|
  table.rows_hash.each do |key, value|
    case key
    when "People"
      value.split(',').each do |name| 
        user = Given "a user named #{name.strip}"
        fill_in 'alert_user_ids', :with => user.id.to_s
      end
    when 'Status', 'Severity'
      select value, :from => key
    when 'Acknowledge', 'Sensitive'
      id = "alert_#{key.parameterize('_')}"
      if value == '<unchecked>'
        uncheck id
      else
        check id
      end
    when 'Communication methods'
      check value
    when /Jurisdiction[s]?/
      select_multiple value.split(',').map(&:strip), :from => 'alert_jurisdiction_ids'
    when /Role[s]?/
      select_multiple value.split(',').map(&:strip), :from => 'alert_role_ids'
    when /Organization[s]?/
      select_multiple value.split(',').map(&:strip), :from => 'alert_organization_ids'
    else
      fill_in key, :with => value
    end
  end
end

Then 'I should see a preview of the message' do
  response.should have_tag('#preview')
end

Then 'I should see a preview of the message with:' do |table|
  table.rows_hash.each do |key, value|
    case key
    when /[Jurisdiction|Role|Organization|People][s]?/
      value.split(',').each do |item|
        response.should have_tag(".#{key.parameterize('_')}", Regexp.new(item.strip))
      end
    else
      response.should have_tag(".#{key.parameterize('_')}", Regexp.new(value))
    end
  end
end

Then 'a foreign alert "$title" is sent to $name' do |title, name|
  When "delayed jobs are processed"
  cascade_alert = CascadeAlert.new(Alert.find_by_title(title))
  organization = Organization.find_by_name!(name)
  File.exist?(File.join(organization.phin_ms_queue, "#{cascade_alert.distribution_id}.edxl")).should be_true
end

Then 'no foreign alert "$title" is sent to $name' do |title, name|
  When "delayed jobs are processed"
  cascade_alert = CascadeAlert.new(Alert.find_by_title(title))
  organization = Organization.find_by_name!(name)
  File.exist?(File.join(organization.phin_ms_queue, "#{cascade_alert.distribution_id}.edxl")).should_not be_true
end

Then 'I see an alert with:' do |table|
  attrs = table.rows_hash
  alert = Alert.find_by_identifier!(attrs['identifier'])
  attrs.each do |attr, value|
    case attr
    when 'jurisdiction'
      alert.jurisdictions.should include(Jurisdiction.find_by_name(value))
    when 'role'
      alert.roles.should include(Role.find_by_name(value))
    when 'from_organization'
      alert.from_organization.should == Organization.find_by_name(value)
    when 'delivery_time'
      alert.delivery_time.should == value.to_i
    when 'sent_at'
      alert.sent_at.should be_close(Time.zone.parse(value), 1)
    when 'acknowledge'
      alert.acknowledge.should == (value == 'Yes')
    else
      alert.send(attr).should == value
    end
  end
end
