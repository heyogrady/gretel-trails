require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require "gretel-trails"

module Dummy
  class Application < Rails::Application
    config.secret_token = "secret token"
    config.active_support.deprecation = :log
    config.eager_load = false
  end
end
