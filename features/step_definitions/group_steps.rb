Given /^the following groups for "([^\"]*)" exist:$/ do |email, table|
  table.raw.each do |row|
    owner = User.find_by_email!(email)
    name, jurisdictions, roles, users, scope, owner_jurisdiction = row
    options = {:owner => owner, :name => name, :scope => scope}
    options[:jurisdictions] = Jurisdiction.find_all_by_name(jurisdictions.split(',')) unless jurisdictions.blank?
    options[:owner_jurisdiction] = Jurisdiction.find_by_name(owner_jurisdiction) unless owner_jurisdiction.blank?
    options[:roles] = Role.find_all_by_name(roles.split(',')) unless roles.blank?
    options[:users] = User.find_all_by_email(users.split(',')) unless users.blank?
    group = Factory(:group, options)
   end
end

Then /^I should see the add group form$/ do
  response.should have_selector("#audience") do |form|
	  form.should have_selector("#group_name")
	  form.should have_selector(".jurisdictions")
    form.should have_selector(".roles")
    form.should have_selector(".people")
  end
end

Then /^I should see the following roles:$/ do |table|
  table.raw.each do |row|
    response.should have_selector(".roles li", :content => row[0])
  end
end

Then /^I should see the following group summary:$/ do |table|
  table.rows_hash.each do |key, value|
    value.split(',').each do |item|
      if key =~ /(name|group_scope|owner_jurisdiction)/i
        response.should have_selector(".#{key}", :content => item)
      else
        response.should have_selector(".#{key} *", :content => item)
      end
    end  
  end
end

When "I fill out the group form with:" do |table|
  fill_in_group_form table
end

Then /^I should see "(.*)" as a groups option$/ do |name|
  response.should have_selector(".groups label", :content => name)
end

Then /^I should see that the group includes\:$/ do |table|
  table.raw.each do |row|
    row[0].split(",").each do |name|
      response.should have_selector(".group_rcpt", :content => name.strip)
    end
  end
end

Then /^I should see the user "(.*)" immediately before "(.*)"$/ do |user1, user2|
   response.should have_selector("li.group_rcpt:nth-child(1)", :content => user1)
   response.should have_selector("li.group_rcpt:nth-child(2)", :content => user2)
end

Then /^the "([^\"]*)" group should not have the following members:$/ do |name, table|
  group = Group.find_by_name(name)
  table.rows_hash.each do |key, value|
    case key
    when "User" 
      group.users.include?(User.find_by_email(value)).should_not be_true
    when "Jurisdiction"
      group.jurisdictions.include?(Jurisdiction.find_by_name(value)).should_not be_true
    when "Role"
      group.roles.include?(Roles.find_by_name(value)).should_not be_true
    else
      raise "I don't know what '#{key}' means, please fix the step definition in #{__FILE__}"
    end
  end
end