# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/app_info/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-app_info'
  spec.version       = Fastlane::AppInfo::VERSION
  spec.author        = 'icyleaf'
  spec.email         = 'icyleaf.cn@gmail.com'

  spec.summary       = 'Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc.'
  spec.homepage      = "https://github.com/icyleaf/fastlane-plugin-app_info"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'app-info', '~> 1.0.3'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.111.0'
end
