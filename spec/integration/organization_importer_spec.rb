require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe  OrgImporter do
context "starting up" do
         OrgImporter.import_orgs('/home/pvittal/code/openphin/db/fixtures/orglist.csv')
end
end