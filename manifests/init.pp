# Class cpan
class cpan (
  $manage_config = true,
  $manage_package = true,
) {
  case $::osfamily {
    Debian: {
      if $manage_package {
        package { 'perl-modules': ensure => installed }
        package { 'gcc': ensure => installed }
        package { 'make': ensure => installed }
      }
      if $manage_config {
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
          source  => 'puppet:///modules/cpan/Config.pm',
          require => File['/etc/perl/CPAN']
        }
      }
    }
    Redhat: {
      if versioncmp($::operatingsystemmajrelease, '6') >= 0 {
        if $manage_package {
          package { 'perl-CPAN': ensure => installed }
          package { 'gcc': ensure => installed }
          package { 'make': ensure => installed }
        }
        if $manage_config {
          file { '/usr/share/perl5/CPAN/Config.pm':
            ensure => present,
            owner  => root,
            group  => root,
            mode   => '0644',
            source => 'puppet:///modules/cpan/Config.pm',
          }
        }
      } else {
        if $manage_config {
          file { '/usr/lib/perl5/5.8.8/CPAN/Config.pm':
            ensure => present,
            owner  => root,
            group  => root,
            mode   => '0644',
            source => 'puppet:///modules/cpan/Config.pm',
          }
        }
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
}
