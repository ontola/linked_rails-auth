# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'linked_rails/auth/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = 'linked_rails-auth'
  spec.version = LinkedRails::Auth::VERSION
  spec.authors = ['Arthur Dingemans']
  spec.email = ['arthur@argu.co']
  spec.homepage = 'https://github.com/ontola/linked_rails-auth'
  spec.summary = 'Easily use devise and doorkeeper in LinkedRails projects'
  spec.license = 'GPL-3.0-or-later'
  spec.required_ruby_version = '>= 2.4.0'

  spec.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'active_model_otp'
  spec.add_dependency 'doorkeeper'
  spec.add_dependency 'doorkeeper-jwt'
  spec.add_dependency 'jwt'
  spec.add_dependency 'rails'
  spec.add_dependency 'rqrcode'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rails'
  spec.add_development_dependency 'sqlite3'
end
