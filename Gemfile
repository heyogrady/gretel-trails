source "http://rubygems.org"

# Declare your gem's dependencies in gretel.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Used by the dummy application
group :development do
  gem "jquery-rails"
  gem "coffee-rails"
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :test do
  gem "test-unit", "~> 3.0" if RUBY_VERSION >= "2.2"
end

# To use debugger
# gem 'debugger'
gem "gretel", github: "lassebunk/gretel"
