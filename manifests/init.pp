# == Class: cpan
#
# Installs cpan
#
# === Parameters
#
# [*manage_config*]
#
# [*manage_package*]
#
# [*installdirs*]
#
# [*local_lib*]
#
# [*config_template*]
#
# [*config_hash*]
#
# [*package_ensure*]
#
# === Examples
#
# class {'::cpan':
#   manage_config  => true,
#   manage_package => true,
#   package_ensure => 'present',
#   installdirs    => 'site',
#   local_lib      => false,
#   config_hash    => { 'build_requires_install_policy' => 'no' },
# }
#
class cpan (
  $manage_config     = $cpan::params::manage_config,
  $manage_package    = $cpan::params::manage_package,
  $installdirs       = $cpan::params::installdirs,
  $local_lib         = $cpan::params::local_lib,
  $config_template   = $cpan::params::config_template,
  $config_hash       = $cpan::params::config_hash,
  $package_ensure    = $cpan::params::package_ensure,
) inherits cpan::params {

  validate_bool($manage_config)
  validate_bool($manage_package)
  validate_string($installdirs)
  validate_bool($local_lib)
  validate_string($config_template)
  validate_string($package_ensure)

  anchor { 'cpan::begin': } ->
  class { '::cpan::install': } ->
  class { '::cpan::config': } ->
  anchor { 'cpan::end': }

}
