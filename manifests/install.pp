# == Class cpan::install
#
# Installs cpan.
#
class cpan::install inherits cpan {

  if $::cpan::manage_package {
    $::cpan::package_name.each |$package| {
      if !defined(Package[$package]) {
        package { $package :
          ensure => $::cpan::package_ensure,
        }
      }
    }
  }
}
