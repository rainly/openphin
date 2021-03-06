Given /^no documents exist$/ do
  Folder.destroy_all
  path = File.join(RAILS_ROOT,'attachments','files')
  Dir.foreach(path) {|filename| 
    next if filename == "." || filename == ".."
    if File.directory?(File.join(path,filename))
      Dir.foreach(File.join(path,filename)) {|fn|
        next if fn == "." || fn == ".."
        File.delete(File.join(path,filename,fn))
      }
    else
      File.delete(File.join(path,filename))
    end
  } if File.exist? path
end

Given 'I have the document "$filename" in my inbox' do |filename|
  @current_user.documents.create! :file => File.open(File.expand_path(RAILS_ROOT+'/spec/fixtures/'+filename))
end

Given /^I have the document "([^\"]*)" in "([^\"]*)"$/ do |filename, foldername|
  @current_user.folders.find_or_create_by_name(
    foldername).documents.create! :user_id => @current_user.id, :file => File.open(File.expand_path(RAILS_ROOT+'/spec/fixtures/'+filename))
end

Given /^I have a folder named "([^\"]*)"$/ do |name|
  current_user.folders.find_or_create_by_name(name)
end

Given /^I have a folder named "([^\"]*)" within "([^\"]*)"$/ do |subname,name|
  folder = current_user.folders.find_or_create_by_name(name)
  subfolder = current_user.folders.find_or_create_by_name(subname)
  subfolder.move_to_child_of(folder)
end

Given 'I have "$count" folders named "$name" with the following documents:' do |count, name, table|
  (1..count.to_i).each do |num|
    current_user.folders.find_or_create_by_name("#{name}#{num.to_s}")
    table.raw.each do |row|
      Given(%Q|I have the document "#{row[0]}" in "#{name}#{num.to_s}"|)
    end
  end
end

When "I fill out the document sharing form with:" do |table|
  fill_in_audience_form table
end

When "I fill out the document sending form with:" do |table|
  fill_in_audience_form table
end

Then 'I should receive the file:' do |table|
  table.rows_hash.each do |header, value|
    case header
    when 'Filename'
      response.header['Content-Disposition'].should == %Q{attachment; filename="#{value}"}
    when 'Content Type'
      response.header['Content-Type'].should == value
    else
      raise "Unknown option: #{header}"
    end
  end
end

Then /^the file "([^\"]*)" in the inbox does not exist$/ do |filename|
  Document.find_by_file_file_name(filename).should be_nil
  Dir[File.join(RAILS_ROOT,'attachments','files',"**",filename)].should be_empty
end

Then /^the file "([^\"]*)" in folder "([^\"]*)" does not exist$/ do |filename, foldername|
  Document.find_by_file_file_name(filename).should be_nil
  Dir[File.join(RAILS_ROOT,'attachments','files',"**",filename)].should be_empty
  Folder.find_by_name(foldername).should_not be_nil
end

Then /^the file "([^\"]*)" and folder "([^\"]*)" do not exist$/ do |filename, foldername|
  Document.find_by_file_file_name(filename).should be_nil
  Dir[File.join(RAILS_ROOT,'attachments','files',"**",filename)].should be_empty
  Folder.find_by_name(foldername).should be_nil
end

Then /^I should see "([^\"]*)" has require confirmation$/ do |arg1|
  response.should have_selector(".folder a[onclick*=\"This folder contains files which will be deleted\"]", :content => "Delete")
end

Then 'I should see "$count" folders named "$folder"' do |count, name|
  (1..count.to_i).each do |num|
    Then(%Q|I should see "#{name}#{num.to_s}"|)
  end
end