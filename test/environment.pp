#
class { '::cpan':
  manage_package => false,
  manage_config  => false,
}

Cpan {
  local_lib => '/tmp/CPAN'
}

cpan { 'DBD::DB2':
  ensure      => present,
  environment => {
    'DB2_HOME' => '/tmp/db2'
  }
}
