# == Class cpan::install
#
# Installs cpan.
#
class cpan::install inherits cpan {

  if $::cpan::manage_package {
    package { $::cpan::package_name :
      ensure => $::cpan::package_ensure,
    }
    if $::cpan::local_lib {
      package { $::cpan::local_lib_package_name :
        ensure => $::cpan::local_lib_package_ensure,
      }
    }
  }
}
