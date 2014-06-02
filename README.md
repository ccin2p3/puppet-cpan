puppet-cpan
===========

Handle installations of cpan modules via puppet.
The force parameter will allow stubborn modules to be installed unattended.

Usage Example
-------------

    include cpan
    cpan { "Clone::Closure":
      ensure  => present,
      require => Class['::cpan'],
      force   => true,
    }

Package Management
------------------
To avoid conflicts with inhouse package management, use:

    class {'cpan':
      manage_package => false,
    }
