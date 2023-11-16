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
# [*package_name*]
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
# [*urllist*]
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
  Boolean $manage_package,
  Hash $config_hash,
  String $package_name,
  Optional[Array[String[1]]] $config_file = undef,
  Optional[Array[String[1]]] $config_dir = undef,
  String $package_ensure        = 'present',
  Boolean $manage_config        = true,
  String $installdirs           = 'site',
  Boolean $local_lib            = false,
  String $config_template       = 'cpan/cpan.conf.erb',
  Optional[String] $ftp_proxy   = undef,
  Optional[String] $http_proxy  = undef,
  Array $urllist                = [],
) {
  anchor { 'cpan::begin': }
  -> class { '::cpan::install': }
  -> class { '::cpan::config': }
  -> anchor { 'cpan::end': }

}
