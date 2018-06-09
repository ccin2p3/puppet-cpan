# == Class: cpan::config
#
# Private class. Should not be called directly.
#
class cpan::config inherits cpan {
  if $::cpan::manage_config {
    case $::osfamily {
      'Debian': {
        file { [ '/etc/perl', '/etc/perl/CPAN' ]:
          ensure => directory,
          owner  => root,
          group  => root,
          mode   => '0755',
          before => File[$perl_config],
        }
      }
      'DragonFly', 'FreeBSD': {
        file { [ '/usr/local/perl5', "/usr/local/perl5/5.${::perl['minversion']}", "/usr/local/perl5/5.${::perl['minversion']}/CPAN" ]:
          ensure => directory,
          owner  => 0,
          group  => 0,
          mode   => '0755',
          before => File[$perl_config],
        }
      }
      default: { }
    }

    file { $::cpan::perl_config:
      ensure  => present,
      owner   => $root_user,
      group   => $root_group,
      mode    => '0644',
      content => template($::cpan::config_template),
    }
  }
}
