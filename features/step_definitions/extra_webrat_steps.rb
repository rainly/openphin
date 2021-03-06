require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When /^I specifically go to ([^\"]*) for "([^\"]*)"$/ do |page_name, arg|
  visit path_to(page_name, arg)
end

Then /^the "([^\"]*)" class selector should contain "([^\"]*)"$/ do |field, value|
  response.should have_selector("*", :class => field, :content => value)
end

Then /^the "([^\"]*)" class selector should not contain "([^\"]*)"$/ do |field, value|
  response.should_not have_selector("*", :class => field, :content => value)
end

Then /^I should see the link "([^\"]*)" that goes to "([^\"]*)"$/ do |value, link|
  response.should have_selector("a", :content => value, :href => link)
end

Then /^I should not see the link "([^\"]*)"$/ do |value|
  response.should_not have_selector("a", :content => value)
end

Then /^I should be specifically on (.+) for "([^\"]*)"$/ do |page_name, arg|
  URI.parse(current_url).path.should == path_to(page_name, arg)
end

Then /^I should explictly see "([^\"]*)" within "([^\"]*)"$/ do |regexp, selector|
  within(selector) do |content|
    regexp = Regexp.new(/^#{regexp}$/)
    content.should contain(regexp)
  end
end
