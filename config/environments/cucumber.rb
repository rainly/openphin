# IMPORTANT: This file was generated by Cucumber 0.4.3
# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.
config.cache_classes = true # This must be true for Cucumber to operate correctly!

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

##don't load backgroundrb in test environment'
config.plugins = config.plugin_locators.map do |locator|
  locator.new(self).plugins
end.flatten.map{|p| p.name.to_sym}
config.plugins -= [:backgroundrb]

config.gem "cucumber",    :lib => false,        :version => ">=0.3.11"
config.gem "rspec",       :lib => false,        :version => ">=1.2.7"
config.gem "rspec-rails", :lib => false,        :version => ">=1.2.7"
config.gem "nokogiri", :version => ">=1.3.3"

config.gem "thoughtbot-factory_girl",
  :lib    => "factory_girl",
  :source => "http://gems.github.com"
config.gem 'bmabey-database_cleaner', :lib => 'database_cleaner',
  :source => 'http://gems.github.com'
config.gem 'spork'

PHIN_PARTNER_OID="1.3.6.1.4.1.1"
PHIN_APP_OID="1"
PHIN_ENV_OID="3"
PHIN_OID_ROOT="#{PHIN_PARTNER_OID}.#{PHIN_ENV_OID}.#{PHIN_APP_OID}"
UPLOAD_BASE_URI = "http://localhost:3000"