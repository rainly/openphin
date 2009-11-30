require File.dirname(__FILE__) + '/../../spec_helper'


describe '/alerts/index.html.erb' do

  before do
    user = Factory(:user)
    template.stub!(:current_user).and_return(user)
    @alert = present Factory(:alert,
      :identifier => 'TX-2009-1',
      :sent_at => 10.minutes.ago,
      :from_jurisdiction => Factory(:jurisdiction),
      :severity => 'Severe',
      :author => user
    )
    assigns[:alerts] = [@alert]
    render
  end
  
  def render
    super 'alerts/index.html.erb'
  end
  
  # | from_jurisdiction | Dallas County |
  # | identifier | TX-2009-9 |
  # | title      | Hello World |
  # | sent_at    | 2009-07-15 20:42:00 UTC |
  # | message_type | Alert |
  
  it "should show the identifier" do
    response.should have_tag('#? .alertid', dom_id(@alert), "Alert ID: #{@alert.identifier}")
  end

  it "should show created_at" do
    response.should have_tag('#? .created_at', dom_id(@alert), "Posted at #{@alert.created_at.to_s(:standard)} by #{@alert.author.display_name}")
  end

  it "should show from_jurisdiction" do
    response.should have_tag('#? .from_jurisdiction', dom_id(@alert), "From: #{@alert.from_jurisdiction.name}")
  end

  it "should show the severity" do
    response.should have_tag('#? .severity', dom_id(@alert), "Severity: #{@alert.severity}")
  end

end
