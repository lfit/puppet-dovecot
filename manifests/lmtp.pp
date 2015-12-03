# dovecot lmtp-only module

class dovecot::lmtp inherits dovecot {


  realize(File['auth-ldap.conf.ext'])
  realize(File['dovecot-ldap.conf.ext'])

  realize(File['10-auth.conf'])
  realize(File['10-mail.conf'])
}
