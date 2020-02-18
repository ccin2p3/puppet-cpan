# == Class: cpan::config
#
# Private class. Should not be called directly.
#
class cpan::config inherits cpan {
  if $::cpan::manage_config {
    unless $cpan::config_dir =~ Undef {
      file { $cpan::config_dir:
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => '0755',
      }
    }
    file { $cpan::config_file:
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template($::cpan::config_template),
    }
  }
}
