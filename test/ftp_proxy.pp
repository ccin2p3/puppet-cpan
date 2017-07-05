#
class { '::cpan':
  manage_package => false,
  manage_config  => true,
  ftp_proxy      => 'http://your_ftp_proxy.com'
}
