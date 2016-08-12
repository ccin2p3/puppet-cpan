source "https://rubygems.org"

group :test do
  gem "rake", '~> 11.2.2'
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.5.3'
  gem "puppet-lint", '~> 2.0.0'
  gem "rspec-puppet", '~> 2.4.0'
  gem "puppetlabs_spec_helper", '~> 1.1.1'
  gem "metadata-json-lint", '~> 0.0.11'
end

group :development do
  gem "travis", '~> 1.8.2'
  gem "travis-lint", '~> 2.0.0'
  gem "guard-rake", '~> 1.0.0'
end
