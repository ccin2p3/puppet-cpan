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

Install Destination
-------------------
To control target installation path, use:

    class {'cpan':
      installdirs => 'vendor'
    }

Any of `site` (default), `perl` and `vendor` are accepted.

To further control the location of installed modules, you can use [local::lib](http://search.cpan.org/perldoc?local::lib):

    cpan { 'Foo::Bar':
      ensure    => present,
      local_lib => '/opt',
    }

This will install the module into `/opt`. Of course you need to adjust `@INC` of your code in order to use that
new location, *e.g.* by using `perl -Mlocal::lib=/opt myapp.pl`.

You can also define the default value of `local_lib` for all `cpan` resources:

    Cpan { local_lib => '/opt' }

