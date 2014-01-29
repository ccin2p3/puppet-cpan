puppet-cpan
===========

Handle installations of cpan modules via puppet.

Usage Example
-------------

    include cpan
    cpan { "Clone::Closure":
      ensure  => present,
      require => Class['::cpan'],
    }
