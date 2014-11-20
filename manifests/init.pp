# Class cpan
class cpan (
  $manage_config = true,
  $manage_package = true,
  $installdirs = 'site',
) {
  unless $installdirs =~ /^(perl|site|vendor)$/ {
    fail("installdirs must be one of {perl,site,vendor}")
  }
  case $::osfamily {
    'Debian': {
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
          content  => template('cpan/Config.pm.erb'),
          require => File['/etc/perl/CPAN']
        }
      }
    }
    'RedHat': {
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
            content  => template('cpan/Config.pm.erb'),
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
            content  => template('cpan/Config.pm.erb'),
          }
        }
      }
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
}
