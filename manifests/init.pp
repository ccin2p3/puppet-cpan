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
# [*ftp_proxy*]
#
# [*http_proxy*]
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
#   ftp_proxy      => 'http://your_ftp_proxy.com',
#   http_proxy     => 'http://your_http_proxy.com',
# }
#
class cpan (
  $manage_config     = $cpan::params::manage_config,
  $manage_package    = $cpan::params::manage_package,
  $installdirs       = $cpan::params::installdirs,
  $local_lib         = $cpan::params::local_lib,
  $config_template   = $cpan::params::config_template,
  $config_hash       = $cpan::params::config_hash,
  $root_user         = $cpan::params::root_user,
  $root_group        = $cpan::params::root_group,
  $package_ensure    = $cpan::params::package_ensure,
  $perl_config       = $cpan::params::perl_config,
  $ftp_proxy         = $cpan::params::ftp_proxy,
  $http_proxy        = $cpan::params::http_proxy,
  $urllist           = $cpan::params::urllist,
) inherits cpan::params {

  validate_bool($manage_config)
  validate_bool($manage_package)
  validate_string($installdirs)
  validate_bool($local_lib)
  validate_string($config_template)
  validate_string($package_ensure)
  if $ftp_proxy {
    validate_string($ftp_proxy)
  }
  if $http_proxy {
    validate_string($http_proxy)
  }
  validate_array($urllist)

  anchor { 'cpan::begin': }
  -> class { '::cpan::install': }
  -> class { '::cpan::config': }
  -> anchor { 'cpan::end': }

}
