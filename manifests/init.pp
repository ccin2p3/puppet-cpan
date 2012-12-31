class cpan {
  case $operatingsystem {
    debian,ubuntu : {
      package { "perl-modules": ensure => installed }
      file { [ "/etc/perl", "/etc/perl/CPAN" ]:
        ensure => directory,
        owner => root,
        group => root,
        mode => 0755,
      }

      file { "/etc/perl/CPAN/Config.pm":
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:///cpan/Config.pm",
        require => File["/etc/perl/CPAN"]
      }
    }
    centos,redhat : {
      file { "/usr/lib/perl5/5.8.8/CPAN/Config.pm":
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:///cpan/Config.pm",
        require => File["/etc/perl/CPAN"]
      }
    }
  }


}
