# dovecot lmtp-only module

class dovecot::imap inherits dovecot {
#  include iptables
#  include iptables::rules

  realize(File['auth-ldap.conf.ext'])
  realize(File['dovecot-ldap.conf.ext'])

  realize(File['10-auth.conf'])
  realize(File['10-mail.conf'])
  realize(File['10-ssl.conf'])

#  realize(Firewall['645 imaps tcp'])

  include dovecot::monitor

}
