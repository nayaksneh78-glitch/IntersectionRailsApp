require "devise/orm/active_record"

Devise.setup do |config|
  config.parent_controller = "ApplicationController"
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.stretches = Rails.env.test? ? 1 : 12
  config.sign_out_via = :delete
end
