class cpan {
  package { "cpan":
    ensure => installed,
  }

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
    source => "puppet:///cpan/Config.pm"
  }

}
