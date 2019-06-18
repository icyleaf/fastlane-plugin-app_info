if ENV['TRAVIS']
  source 'https://rubygems.org'
else
  source 'https://gems.ruby-china.com'
end

gemspec

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
