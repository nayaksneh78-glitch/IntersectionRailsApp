require_relative "boot"
require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "active_job/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module InterSection
  class Application < Rails::Application
    config.load_defaults 7.2
    config.generators.system_tests = nil
    config.filter_parameters += %i[password token authorization]

    # Avoid collisions when Windows processes replace the same asset cache file.
    if Gem.win_platform?
      config.assets.configure do |environment|
        environment.cache = Sprockets::Cache::MemoryStore.new
      end
    end
  end
end
