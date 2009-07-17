module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/i
      root_path
    when /the dashboard page/i
      dashboard_path
    when /the sign up page/i
      new_user_path
    when /the sign in page/i
      new_session_path
    when /the password reset request page/i
      new_password_path
    when /the request a role page/i
      new_role_request_path
    when /the alerts page/i
      alerts_path
    when /the logs page/i
      logs_path
    when /the roles requests page for an admin/
      admin_role_requests_path
      
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end
 
World(NavigationHelpers)
