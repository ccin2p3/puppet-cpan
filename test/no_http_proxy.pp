#
class { '::cpan':
  manage_package => false,
  manage_config  => true,
  http_proxy     => undef
}
