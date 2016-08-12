#
class { '::cpan':
  manage_package => false,
  manage_config  => false,
}

cpan { 'Riemann::Client':
  ensure    => present,
  local_lib => false
}
