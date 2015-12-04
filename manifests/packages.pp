class dovecot::packages {

  ensure_resource('package',
    [
      'dovecot',
    ],
    {
      'ensure' => 'installed'
    }
  )
}
