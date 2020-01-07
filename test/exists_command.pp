#
class { '::cpan':
  manage_package => false,
  manage_config  => false,
}

cpan { 'Sys::RunAlone':
  ensure         => present,
  exists_command => 'perl -Mlocal::lib=/tmp/cpan -M% -e"__END__"',
  local_lib      => '/tmp/cpan',
}
