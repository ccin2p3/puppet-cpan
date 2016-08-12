# == Class cpan::install
#
# Installs cpan.
#
class cpan::install inherits cpan {

  if $::cpan::manage_package {
    package { $::cpan::package_name :
      ensure => $::cpan::package_ensure,
    }
  }
}
