# == Class cpan::install
#
# Installs cpan.
#
class cpan::install inherits cpan {

  if $::cpan::manage_package {
    if !defined(Package[$package_name]) {
      package { $::cpan::package_name :
        ensure => $::cpan::package_ensure,
      }
    }
  }
}
