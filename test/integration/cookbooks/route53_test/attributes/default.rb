default['route53']['zone_id'] = 'Z2DEMODEMODEMO'

default['records']['generic_record']['name'] = 'kitchen-test.yourdomain.org'
default['records']['generic_record']['value'] = '16.8.4.3'
default['records']['generic_record']['type'] = 'A'
default['records']['generic_record']['ttl'] = 3600

default['records']['alias_record']['name'] = 'kitchen-test-alias.yourdomain.org'
default['records']['alias_record']['alias_target']['dns_name'] = 'dns-name'
default['records']['alias_record']['alias_target']['hosted_zone_id'] = 'host-zone-id'
default['records']['alias_record']['alias_target']['evaluate_target_health'] = false
default['records']['alias_record']['type'] = 'A'
default['records']['alias_record']['run'] = true
