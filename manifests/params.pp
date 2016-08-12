# == Class: cpan::params
#
# Parameters for cpan class
#
class cpan::params {

  $manage_config     = true
  $installdirs       = 'site'
  $local_lib         = false
  $config_template   = 'cpan/cpan.conf.erb'
  $config_hash       = { 'build_requires_install_policy' => 'no' }
  $package_ensure    = 'present'
  $common_package    = ['gcc','make']

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
      if $local_lib {
        $local_lib_package  = ['liblocal-lib-perl']
      } else {
        $local_lib_package  = []
      }
    }
    'RedHat': {
      $common_os_package = ['perl-CPAN']

      if $local_lib {
        if ($::operatingsystem == 'RedHat' and versioncmp($::operatingsystemmajrelease, '6') >= 0) {
          $local_lib_package  = ['perl-local-lib']
        } elsif  ($::operatingsystem == 'Fedora' and versioncmp($::operatingsystemmajrelease, '16') >=0) {
          $local_lib_package  = ['perl-local-lib']
        }
      } else {
        $local_lib_package  = []
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
  $package_name =  concat($common_package,$common_os_package,$local_lib_package )
}
