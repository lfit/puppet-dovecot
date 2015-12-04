# == Class: dovecot
#
# This class is the entry point into installing and configuring
# a dovecot instance.
#
# === Parameters
# 
# === Authors
# 
# Clint Savage <csavage@linuxfoundation.org>
# Ryan Finnin Day <rday@linuxfoundation.org>
#


class dovecot(
  $ssl_cert_name = $dovecot::params::ssl_cert_name,
  $protocols     = $dovecot::params::protocols,
  ) inherits dovecot::params {

  include ::dovecot::packages
  include ::dovecot::service

  # local variables for use in templates
  $mycert = dovecot::ssl_cert_name
  $dovecot_protocols = hiera('dovecot::protocols')

  user { 'vmail':
    uid        => '491',
    gid        => '491',
    home       => '/var/vmail',
    managehome => false,
    require    => [
      Group['vmail'],
    ],
  }

  group { 'vmail':
    gid => '491',
  }

  File {
    require => [ Package['dovecot'] ],
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { 'dovecot_conf-imap':
    name    => '/etc/dovecot/dovecot.conf',
    content => template('dovecot/dovecot.conf.erb'),
    notify  => [
      Service['dovecot'],
    ],
  }

  file { '10-master_conf-imap':
    name   => '/etc/dovecot/conf.d/10-master.conf',
    source => [
      'puppet:///modules/dovecot/10-master.conf',
    ],
    notify => [
      Service['dovecot'],
    ],
  }

  @file { 'dovecot-ldap.conf.ext':
    name    => '/etc/dovecot/conf.d/dovecot-ldap.conf.ext',
    owner   => root,
    group   => root,
    mode    => '0600',
    source  => "puppet:///modules/private/dovecot/dovecot-ldap.conf.ext",
    require => [
      Package['dovecot'],
    ],
    notify  => Service['dovecot'],
  }

  @file { 'auth-ldap.conf.ext':
    name   => '/etc/dovecot/conf.d/auth-ldap.conf.ext',
    source => [
      "puppet:///modules/dovecot/auth-ldap.conf.ext",
    ],
    notify  => [
      Service['dovecot'],
    ],
  }

  @file { '10-auth.conf':
    name   => '/etc/dovecot/conf.d/10-auth.conf',
    source => [
      "puppet:///modules/dovecot/10-auth.conf",
    ],
    notify  => [
      Service['dovecot'],
      File['auth-ldap.conf.ext'],
    ],
  }

  @file { '10-mail.conf':
    name    => '/etc/dovecot/conf.d/10-mail.conf',
    source  => [
      "puppet:///modules/dovecot/10-mail.conf",
    ],
    require => [
      User['vmail'],
    ],
    notify  => [
      Service['dovecot'],
    ],
  }

#  include private::dovecot

  @file { '10-ssl.conf':
    name    => '/etc/dovecot/conf.d/10-ssl.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('dovecot/10-ssl.conf.erb'),
    notify  => [
      Service['dovecot'],
    ],
  }

  file { '/var/vmail':
    ensure  => directory,
    owner   => 'root',
    group   => 'vmail',
    mode    => '0770',
  }

}
