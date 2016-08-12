#
class { '::cpan':
  manage_package => false,
  manage_config  => false,
}

Cpan {
  local_lib => '/tmp/CPAN'
}

cpan { 'Riemann::Client':
  ensure    => present,
}
