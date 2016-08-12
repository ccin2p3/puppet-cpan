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
        }
        file { '/etc/perl/CPAN/Config.pm':
          ensure  => present,
          owner   => root,
          group   => root,
          mode    => '0644',
          content => template($::cpan::config_template),
          require => File['/etc/perl/CPAN'],
        }
      }
      'RedHat': {
        if versioncmp($::operatingsystemmajrelease, '6') >= 0  and $::operatingsystem != 'Fedora' {
          file { '/usr/share/perl5/CPAN/Config.pm':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template($::cpan::config_template),
          }
        } else {
          file { '/usr/lib/perl5/5.8.8/CPAN/Config.pm':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template($::cpan::config_template),
          }
        }
      }
      default: {
        fail("Module ${module_name} is not supported on ${::osfamily} os.")
      }
    }
  }
}
