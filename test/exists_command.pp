#
class { '::cpan':
  manage_package => false,
  manage_config  => false,
}

cpan { 'Sys::RunAlone':
  ensure          => present,
  exists_strategy => 'find',
  local_lib       => '/tmp/cpan',
}

cpan { 'Class::AccessorMaker':
  ensure          => present,
  exists_strategy => 'find',
  local_lib       => '/tmp/cpan',
}

cpan { 'Riemann::Client':
  ensure          => present,
  exists_strategy => 'include',
  local_lib       => '/tmp/cpan',
}
