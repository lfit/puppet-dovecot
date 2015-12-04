class dovecot::service {

  service { 'dovecot':
    ensure => running,
    enable => true,
    require => [
      Package['dovecot'],
    ],
  }
}
