source 'https://rubygems.org'

group :development, :test do
	gem 'rake', :require => false
	gem 'rspec-puppet', :require => false
	gem 'puppetlabs_spec_helper', :require => false
	gem 'serverspec', :require => false
	gem 'puppet-lint', :require => false
	gem 'beaker-rspec', :require => false
	gem 'puppet_facts', :require => false
end

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']
gem 'puppet', puppetversion
gem 'facter', '>= 1.7.0'
