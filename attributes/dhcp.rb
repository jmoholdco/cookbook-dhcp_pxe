default['dhcp'] = {
  'domain' => 'jmorgan.org',
  'name_servers' => %w( 192.168.1.8 192.168.1.9 ),
  'lease_time' => {
    'default' => '600',
    'max' => '7200'
  },
  'ddns' => {
    'update_style' => 'interim'
  },
  'authoritative' => true,
  'subnet' => '192.168.1.0',
  'netmask' => '255.255.255.0',
  'routers' => '192.168.1.1',
  'broadcast' => '192.168.1.255',
  'range' => {
    'low' => '192.168.1.30',
    'hi' => '192.168.1.245'
  }
}
