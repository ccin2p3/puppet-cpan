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
  $manage_package,
  $config_hash,
  $package_name,
  Optional[Array[String[1]]] $config_file = undef,
  Optional[Array[String[1]]] $config_dir = undef,
  $package_ensure    = 'present',
  $manage_config     = true,
  $installdirs       = 'site',
  $local_lib         = false,
  $config_template   = 'cpan/cpan.conf.erb',
  $ftp_proxy         = undef,
  $http_proxy        = undef,
  $urllist           = [],
) {

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
