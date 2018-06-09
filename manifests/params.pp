# == Class: cpan::params
#
# Parameters for cpan class
#
class cpan::params {

  $manage_config   = true
  $installdirs     = 'site'
  $local_lib       = false
  $config_template = 'cpan/cpan.conf.erb'
  $config_hash     = { 'build_requires_install_policy' => 'no' }
  $package_ensure  = 'present'
  $common_package  = ['gcc','make']
  $ftp_proxy       = undef
  $http_proxy      = undef
  $urllist         = []

  unless $installdirs =~ /^(perl|site|vendor)$/ {
    fail('installdirs must be one of {perl,site,vendor}')
  }

  $manage_package = $::osfamily ? {
    'Debian' => true,
    'Redhat' => true,
    default  => false,
  }
  case $::osfamily {
    'Debian': {
      $common_os_package = ['perl-modules']
      $perl_config = '/etc/perl/CPAN/Config.pm'
      $root_user   = 'root'
      $root_group  = 'root'
      if $local_lib {
        $local_lib_package = ['liblocal-lib-perl']
      } else {
        $local_lib_package = []
      }
    }
    'RedHat': {
      $common_os_package = ['perl-CPAN']
      case $::operatingsystemmajrelease {
        5, 6: {
          $local_lib_package = ['perl-local-lib']
          $perl_config = '/usr/share/perl5/CPAN/Config.pm'
          $root_user   = 'root'
          $root_group  = 'root'
        }
        7: {
          $root_user   = 'root'
          $root_group  = 'wheel'
        }
        default: { }
      }
    }
    'DragonFly', 'FreeBSD': {
      $perl_config = "/usr/local/perl5/5.${::perl['minversion']}/CPAN/Config.pm"
      $root_user   = 'root'
      $root_group  = 'wheel'
      $local_lib_package = []
      $common_os_package = []
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
  $package_name = concat($common_package,$common_os_package,$local_lib_package)
}
