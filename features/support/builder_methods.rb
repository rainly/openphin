module FeatureHelpers
  module BuilderMethods
    def create_alert_with(attributes)
      attributes['from_jurisdiction'] = Jurisdiction.find_by_name(attributes['from_jurisdiction']) unless attributes['from_jurisdiction'].blank?
      attributes['jurisdictions'] = attributes['jurisdictions'].split(',').map{|m| Jurisdiction.find_by_name(m.strip)} unless attributes['jurisdictions'].blank?
      attributes['organizations'] = attributes['organizations'].split(',').map{|m| Organization.find_by_name(m.strip)} unless attributes['organizations'].blank?
      attributes['roles'] = attributes['roles'].split(',').map{|m| Role.find_by_name(m.strip)} unless attributes['roles'].blank?

      if attributes.has_key?('people')
        attributes['user_ids'] = attributes.delete('people').split(',').map{ |m|
          first_name, last_name = m.split(/\s+/) 
          User.find_by_first_name_and_last_name(first_name, last_name)
        } 
      end
  
      if attributes['author'].blank?
        attributes['author_id'] = current_user.id unless current_user.nil?
      else
        attributes['author_id'] = User.find_by_display_name(attributes.delete('author')).id
      end

      if attributes.has_key?('acknowledge')
        attributes['acknowledge'] = true_or_false(attributes.delete('acknowledge'))
      end

      Factory(:alert, attributes)  
    end
  end
end

World(FeatureHelpers::BuilderMethods)