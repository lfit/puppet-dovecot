class dovecot::monitor {
#  nagios::resource { "tcp-connect-imaps-${::fqdn}":
#    type                  => 'service',
#    service_description   => 'IMAPS port connect',
#    check_command         => 'check_tcp!993',
#    normal_check_interval => 1,
#    service_use           => 'generic-service',
#    export                => true,
#  }
}
