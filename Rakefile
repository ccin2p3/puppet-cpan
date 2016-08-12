require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'

  # Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
  # http://puppet-lint.com/checks/class_parameter_defaults/
  # http://puppet-lint.com/checks/class_inherits_from_params_class/
  config.disable_checks = [
    "class_inherits_from_params_class",
    "80chars",
    "puppet_url_without_modules",
    "inherits_across_namespaces",
    "class_parameter_defaults"
  ]
  config.fail_on_warnings = true
  config.relative = true
end

PuppetSyntax.exclude_paths = exclude_paths

task :metadata do
  sh "bundle exec metadata-json-lint metadata.json"
end

Rake::Task[:default].clear
desc 'Run test by default'
task :default => [:test]

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec,
  :metadata_lint,
]
